//
//  GameFunctions.swift
//  theGame
//
//  Created by Alan D. Yoho on 4/25/18.
//  Copyright © 2018 Alan D. Yoho. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit
import UIKit
//import SwiftGifOrigin
//asteroids at 10
//flames at 10
//spaceship at 15
//flametrail at 14
//shields at 13
//backgounrd at 6
//loseNotification at 20
//powerups at 10
//pulse at 10
extension GameScene {
    
    
    func createAsteroids() -> SKSpriteNode {
            let asteroid = SKSpriteNode(imageNamed: "asteroid")
            asteroid.name = "ASTEROID"
        let type = Asteroids(rawValue: GKRandomSource.sharedRandom().nextInt(upperBound: 4))!
        switch type {
        case .small: asteroid.scale(to: CGSize(width: 50, height: 50))
            
        case .medium:
            asteroid.scale(to: CGSize(width: 100, height: 100))
            
        case .large:
            asteroid.scale(to: CGSize(width: 150, height: 150))
        case .extraLarge: asteroid.scale(to: CGSize(width: 175, height: 175))
        }
        
        let randomPositionForAsteroid = GKRandomSource.sharedRandom().nextInt(upperBound: Int(frame.maxX - asteroid.frame.maxX))
        let randomSpeedOfAsteroid = GKRandomSource.sharedRandom().nextInt(upperBound: 3)
            asteroid.zPosition = 10
        
        //set physicsBody
        asteroid.physicsBody = SKPhysicsBody(circleOfRadius: asteroid.size.width/2)
        asteroid.physicsBody?.categoryBitMask = asteroidCategory
        asteroid.physicsBody?.velocity = CGVector(dx: 0, dy: -velocities[randomSpeedOfAsteroid])
        asteroid.position = CGPoint(x: randomPositionForAsteroid, y: Int(frame.maxY))
        asteroid.physicsBody?.collisionBitMask = 0


        let flames = SKEmitterNode(fileNamed: "fireworks")
        flames?.setScale(3)
        flames?.zPosition = 10
        asteroid.addChild(flames!)
        flames?.name = "flames"
        flames?.position = CGPoint(x: 0, y: 0)
            return asteroid
    }
    
    func randomlySpawnEnemies(numberOfEnemies: Int = 2) {
        for _ in 0...numberOfEnemies {
            self.addChild(createAsteroids())
        }
        self.enumerateChildNodes(withName: "ASTEROID") { (node: SKNode, nil) in
            if node.position.y < -150 {
                
                node.removeFromParent()
//                print("asteroid removed!")
            }
        }
    }
    
 
    
    func randomlySpawnAlteredEnemies(numberOfEnemies: Int = 2) {
        for _ in 0...numberOfEnemies {
                self.addChild(spawnAlteredAsteroids(desiredSpeed: 2000))
                SKAction.wait(forDuration: 2.0)

        }
        self.enumerateChildNodes(withName: "ASTEROID") { (node: SKNode, nil) in
            if node.position.y < -150 {
                
                node.removeFromParent()
//                                print("altered node removed!")
            }
        }
    }
    func delay(time: Double, closure:@escaping ()->()) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + time) {
            closure()
        }
        
    }
    
    func spawnSpaceship() {
        
        spaceship = SKSpriteNode(imageNamed: "spaceship")
        spaceship!.name = "SPACESHIP"
//        print(spaceship?.size)
//        Optional((74.0, 153.0))

        spaceship!.scale(to: CGSize(width: 74, height: 153))
        spaceship!.position = CGPoint(x: self.frame.width/2, y: 0)
        let gameStart = SKAction.move(to: CGPoint(x: self.frame.width/2, y: 160), duration: 0.5)
        spaceship?.run(gameStart)
        spaceship!.zPosition = 15
        
        spaceship?.physicsBody = SKPhysicsBody(circleOfRadius: spaceship!.size.width/2)
        spaceship?.physicsBody?.linearDamping = 0
        spaceship?.physicsBody?.categoryBitMask = spaceshipCategory
        spaceship?.physicsBody?.contactTestBitMask = asteroidCategory | gunsCategory | shieldsCategory | turbosCategory | boundaryCategory
        pew?.physicsBody?.contactTestBitMask = asteroidCategory
        
        spaceship?.physicsBody?.collisionBitMask = 0

        self.addChild(spaceship!)
        let flameTrail = SKEmitterNode(fileNamed: "flameTrail")
//        flameTrail?.setScale(3)
        flameTrail?.particleZPosition = 14
        flameTrail?.name = "flameTrail"
        flameTrail?.targetNode = self
        flameTrail?.position = CGPoint(x: (spaceship?.frame.width)!/2 - 33
            , y: (spaceship?.frame.minY)!)
        flameTrail?.particleScale = CGFloat(0.25)
        flameTrail?.physicsBody?.allowsRotation = false
        flameTrail?.physicsBody?.isResting = true
        
        spaceship?.addChild(flameTrail!)
    }
    @objc func removeShield() {
        spaceship?.childNode(withName: "shield")?.removeFromParent()
//        print("shields removed")
        hasShield = false
    }
    
    func addExplosionEffect() {
        let explosion = SKEmitterNode(fileNamed: "explosion")
        explosion?.setScale(4)
        spaceship?.addChild(explosion!)
    }

    
    
    func moveLeft(left: Bool) {
        let origin: CGPoint = CGPoint(x: 0, y: 0)
        if left {
            wingLeft()
            let moveAction = SKAction.moveBy(x: -5, y: 0, duration: 0.01)
            let repeatAction = SKAction.repeatForever(moveAction)

                spaceship?.run(repeatAction)
            
//            print(frame.size)
//            print(frame.minX)
//            print(frame.maxX)
        
            (750.0, 1334.0)
            -0.0
            750.0

        } else {
            wingRight()
            let moveAction = SKAction.moveBy(x: 5, y: 0, duration: 0.01)

            let repeatAction = SKAction.repeatForever(moveAction)

                spaceship?.run(repeatAction)
        }
    }
    
    @objc func updateTimer() {
        if seconds > 0 {
        
            countdown.text = "\(seconds)"
            seconds -= 1

        } else {
            timer.invalidate()
            countdown.text = ""
            countdown.removeFromParent()
            seconds = 10
//            print("seconds reset to 10")
            
            
        }

        
//        print("updateTimerMethod called")
        
    }
    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(GameScene.updateTimer)), userInfo: nil, repeats: true)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        var spaceshipBody: SKPhysicsBody
        var otherBody: SKPhysicsBody
        var pewBody: SKPhysicsBody
        if contact.bodyA.categoryBitMask == pewCategory && contact.bodyB.categoryBitMask == asteroidCategory {
            print("contact!!!")
        }
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            spaceshipBody = contact.bodyA
            otherBody = contact.bodyB
        } else {
            spaceshipBody = contact.bodyB
            otherBody = contact.bodyA
        }
        
        if spaceshipBody.categoryBitMask == spaceshipCategory && otherBody.categoryBitMask == shieldsCategory {
//            print("shields hit")
            let shield = SKSpriteNode(imageNamed: "shield")
            //        flameTrail?.setScale(3)
            spaceship?.addChild(shield)
            shield.name = "shield"
            
            shield.position = CGPoint(x: 0, y: 0)
            hasShield = true
            
            countdown.fontSize = 100
            countdown.fontColor = .red
            countdown.zPosition = 1000
            countdown.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
            self.addChild(countdown)
            runTimer()
            self.perform(#selector(GameScene.removeShield), with: nil, afterDelay: 11.0)
            
        } else if spaceshipBody.categoryBitMask == spaceshipCategory && otherBody.categoryBitMask == turbosCategory {
//            print("turbos hit")
            let image1 = UIImage(named: "pic1")!
            
            let image2 = UIImage(named: "pic2")!
            
            
            let background = InfiniteScrollingBackground(images: [image1, image2], scene: self, scrollDirection: .bottom, speed: 1)
            background?.zPosition = 6
            background?.scroll()
            randomlySpawnAlteredEnemies()
            
            
            self.perform(#selector(GameScene.resetBackground), with: nil, afterDelay: 10.0)

        } else if spaceshipBody.categoryBitMask == spaceshipCategory && otherBody.categoryBitMask == gunsCategory {
//            print("guns hit")
            summonPew()
        } else if spaceshipBody.categoryBitMask == spaceshipCategory && otherBody.categoryBitMask == asteroidCategory {
//            print("asteroid hit boiiii")
            if hasShield == true {
                
                otherBody.collisionBitMask = spaceshipCategory
            } else {
                addExplosionEffect()
                GameViewController.health -= 1
                
            }
            otherBody.collisionBitMask = asteroidCategory

            
                if GameViewController.health == 0 {
                    
                    childNode(withName: "leftPad")?.isHidden = true
                    childNode(withName: "rightPad")?.isHidden = true


//                gameBackgroundMusic.run(pause)
                loseNotification = SKSpriteNode(imageNamed: "youLose")
                loseNotification?.name = "loseNotification"
                loseNotification?.position = CGPoint(x: self.frame.maxX/2, y: self.frame.maxY/2)
                loseNotification?.zPosition = 20
                loseNotification?.alpha = 0
                loseNotification?.scale(to: CGSize(width: self.frame.maxX, height: self.frame.maxY))
                    self.addChild(loseNotification!)
                let fade = SKAction.fadeAlpha(to: 1, duration: 1)
                    loseNotification?.run(fade)
                    
                    
                
              
        }
        } else {
            print("asteroid hit with pew")
        }
        score?.text = "\(GameViewController.health)"
        
        
        

    }
    
 
    
    func createPowerUps () -> SKSpriteNode {
        var powerUp: SKSpriteNode!
        let type = PowerUps(rawValue: GKRandomSource.sharedRandom().nextInt(upperBound: 3))!
        switch type {
        case .turbos:
            powerUp = SKSpriteNode(imageNamed: "turbos")
            powerUp.physicsBody = SKPhysicsBody(circleOfRadius: powerUp.size.width/2)

            powerUp.physicsBody?.categoryBitMask = turbosCategory
        case .guns:
            powerUp = SKSpriteNode(imageNamed: "guns")
            powerUp.physicsBody = SKPhysicsBody(circleOfRadius: powerUp.size.width/2)

            powerUp.physicsBody?.categoryBitMask = gunsCategory

        case .shields:
            powerUp = SKSpriteNode(imageNamed: "shields")
            powerUp.physicsBody = SKPhysicsBody(circleOfRadius: powerUp.size.width/2)

            powerUp.physicsBody?.categoryBitMask = shieldsCategory
        }
        
        powerUp.name = "powerUp"
        powerUp.scale(to: CGSize(width: 50, height: 50))

        
        let randomPositionForPowerUp = GKRandomSource.sharedRandom().nextInt(upperBound: Int(frame.maxX - powerUp.frame.maxX))
        let randomSpeedOfPowerUp = GKRandomSource.sharedRandom().nextInt(upperBound: 3)
        powerUp.zPosition = 10
        
        //set physicsBody
        powerUp.physicsBody?.velocity = CGVector(dx: 0, dy: -velocities[randomSpeedOfPowerUp])
        powerUp.position = CGPoint(x: randomPositionForPowerUp, y: Int(frame.maxY))
        powerUp.physicsBody?.collisionBitMask = 0
        
        let pulse = SKEmitterNode(fileNamed: "pulse")
        pulse?.setScale(3)
        pulse?.zPosition = 10
        powerUp.addChild(pulse!)
        pulse?.position = CGPoint(x: 0, y: 0)
        return powerUp
    }
    

    func randomlySpawnPowerUps(numberOfPowerUps: Int = 1) {
        for _ in 0...numberOfPowerUps {
            self.addChild(createPowerUps())
            
        }
        self.enumerateChildNodes(withName: "powerUp") { (node: SKNode, nil) in
            if node.position.y < -150 {
                
                node.removeFromParent()
//                print("powerUP removed!")
            }
        }
    }
    
    func spawnAlteredAsteroids(desiredSpeed: Int) -> SKSpriteNode {
        let asteroid = SKSpriteNode(imageNamed: "asteroid")
        asteroid.name = "ASTEROID"
        let type = Asteroids(rawValue: GKRandomSource.sharedRandom().nextInt(upperBound: 4))!
        switch type {
        case .small: asteroid.scale(to: CGSize(width: 50, height: 50))
            
        case .medium:
            asteroid.scale(to: CGSize(width: 100, height: 100))
            
        case .large:
            asteroid.scale(to: CGSize(width: 150, height: 150))
        case .extraLarge: asteroid.scale(to: CGSize(width: 175, height: 175))
        }
        
        let randomPositionForAsteroid = GKRandomSource.sharedRandom().nextInt(upperBound: Int(frame.maxX - asteroid.frame.maxX))
        asteroid.zPosition = 10
        
        //set physicsBody
        asteroid.physicsBody = SKPhysicsBody(circleOfRadius: asteroid.size.width/2)
        asteroid.physicsBody?.categoryBitMask = asteroidCategory
        asteroid.physicsBody?.velocity = CGVector(dx: 0, dy: -desiredSpeed)
        asteroid.position = CGPoint(x: randomPositionForAsteroid, y: Int(frame.maxY))
        asteroid.physicsBody?.collisionBitMask = 0
        
        let flames = SKEmitterNode(fileNamed: "fireworks")
        flames?.setScale(3)
        flames?.zPosition = 10
        asteroid.addChild(flames!)
        flames?.position = CGPoint(x: 0, y: 0)
        return asteroid
    }
    
    func wingLeft() {
        spaceship?.texture = SKTexture(imageNamed: "spaceshipLeft")
        leftOrRight = true

    }
    func wingRight() {
        spaceship?.texture = SKTexture(imageNamed: "spaceshipRight")
        leftOrRight = false
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        var moveAction: SKAction
        
        if leftOrRight {
            moveAction = SKAction.moveBy(x: 5, y: 0, duration: 0.01)

        } else {
            moveAction = SKAction.moveBy(x: -5, y: 0, duration: 0.01)

        }
        let repeatAction = SKAction.repeatForever(moveAction)
        spaceship?.texture = SKTexture(imageNamed: "spaceship")
        spaceship?.run(repeatAction)
    }
    func spawnBoundary() {
        
        let boundary1 = SKSpriteNode(imageNamed: "boundary")
        let boundary2 = SKSpriteNode(imageNamed: "boundary")

//        boundary1.anchorPoint = CGPoint(x: boundary1.frame.size.width/2, y: boundary1.frame.size.height/2)
        boundary1.position = CGPoint(x: 1, y: 0)
        boundary2.position = CGPoint(x: 750, y: 0)

        boundary1.zPosition = 15
        boundary1.physicsBody?.categoryBitMask = boundaryCategory
        boundary1.physicsBody?.collisionBitMask = spaceshipCategory
        
        boundary2.zPosition = 15
        boundary2.physicsBody?.categoryBitMask = boundaryCategory
        
        boundary2.physicsBody?.collisionBitMask = spaceshipCategory

        self.addChild(boundary1)
        self.addChild(boundary2)
        
        
    }
    @objc func resetBackground() -> Any {
        let image1 = UIImage(named: "pic1")!
        
        let image2 = UIImage(named: "pic2")!
        let background = InfiniteScrollingBackground(images: [image1, image2], scene: self, scrollDirection: .bottom, speed: 3)
        return background
    }
    
    func summonPew() {
        pew = SKSpriteNode(fileNamed: "pew")
//        pew?.physicsBody = SKPhysicsBody(circleOfRadius: 20)
//        pew?.physicsBody?.affectedByGravity = false
//        pew?.physicsBody?.mass = 1000
//        pew?.physicsBody?.collisionBitMask = asteroidCategory
//        pew?.physicsBody?.categoryBitMask = pewCategory
        pew?.position = CGPoint(x: 0, y: 0)
        
        print("pew size: \(pew?.size)")
        pew?.size = CGSize(width: 20, height: 20)
        
        let spawn = SKAction.run {
            self.pew = SKSpriteNode(fileNamed: "pew")
            
        }
        let shoot = SKAction.moveBy(x: 0, y: 3000, duration: 0.5)
        let fadeOut = SKAction.fadeOut(withDuration: 0.1)
        let fadeIn = SKAction.fadeIn(withDuration: 0.1)
        let shootBack = SKAction.moveBy(x: 0, y: -3000, duration: 0.1)
        let wait = SKAction.wait(forDuration: 0.01)
        
        let shootWait = SKAction.sequence([shoot,fadeOut,shootBack,fadeIn,wait])
        let shootWaitForever = SKAction.repeatForever(shootWait)

        spaceship?.addChild(pew!)
        pew?.run(shootWaitForever)

        
    }
}
