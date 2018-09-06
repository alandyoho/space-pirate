//
//  GameScene.swift
//  theGame
//
//  Created by Alan D. Yoho on 4/23/18.
//  Copyright © 2018 Alan D. Yoho. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    var seconds = 10
    var timer = Timer()
    var isTimerRunning = false
    var score: SKLabelNode?
    var loseNotification : SKSpriteNode?
    var hasShield: Bool = false
    var leftOrRight: Bool = true
    @IBOutlet weak var healthGauge: UILabel!
    var spaceship: SKSpriteNode?
    var pew: SKSpriteNode?
    
    let spaceshipCategory: UInt32 = 0x1 << 1
    let shieldsCategory: UInt32 = 0x1 << 2
    let turbosCategory: UInt32 = 0x1 << 3
    let gunsCategory: UInt32 = 0x1 << 4
    let asteroidCategory: UInt32 = 0x1 << 5
    let boundaryCategory: UInt32 = 0x1 << 6
    let pewCategory: UInt32 = 0x1 << 7
    
    
    var velocities = [500, 600, 700]
    
    var powerUpCount: Int = 0

    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    let play = SKAction.play()
    let pause = SKAction.pause()
    var isPlaying = Bool()
    var gameBackgroundMusic = SKAudioNode(fileNamed: "AppIdea1.m4a")

    var countdown = SKLabelNode()


    
    

    override func didMove(to view: SKView) {
        for i in 0...5 {
            delay(time: 10, closure: {
                print("the time is now: \(i)")
            })
        }
//        gameBackgroundMusic.run(play)
//        print(gameBackgroundMusic.isPaused)
        gameBackgroundMusic.autoplayLooped = true
//        self.addChild(gameBackgroundMusic)

        
        score = SKLabelNode(text: "\(GameViewController.health)")
        score?.position = CGPoint(x: 650, y: 80)
        score?.fontSize = 60
        score?.fontColor = .red
        score?.zPosition = 100
        self.addChild(score!)

        spawnBoundary()
        gameBackgroundMusic.run(play)
        
        
        self.physicsWorld.contactDelegate = self
        let image1 = UIImage(named: "pic1")!

        let image2 = UIImage(named: "pic2")!
        
        let background = InfiniteScrollingBackground(images: [image1, image2], scene: self, scrollDirection: .bottom, speed: 3)
        background?.zPosition = 5
        
        background?.scroll()
        randomlySpawnEnemies()
        randomlySpawnPowerUps()
//        spawnSpaceship()
        self.run(SKAction.repeatForever(SKAction.sequence([SKAction.run {
            self.randomlySpawnEnemies()
            }, SKAction.wait(forDuration: 2.0)])))
       
        self.run(SKAction.repeatForever(SKAction.sequence([SKAction.run {
            self.randomlySpawnPowerUps()
            }, SKAction.wait(forDuration: 20)])))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if GameViewController.startGame == true {
            childNode(withName: "leftPad")?.isHidden = false
            childNode(withName: "rightPad")?.isHidden = false
            spawnSpaceship()
            GameViewController.startGame = false
            
        }

        if let touch = touches.first {
            let location = touch.location(in: self)
            let node = self.nodes(at: location).first
            
            if node?.name == "rightPad" {
                moveLeft(left: false)

            } else if node?.name == "leftPad"{
                moveLeft(left: true)
                print("left pad tapped")
                
            } else if node?.name == "loseNotification" {
                print("time to restart the game")
                if let scene = SKScene(fileNamed: "GameScene") {
                    // Set the scale mode to scale to fit the window
                    scene.scaleMode = .aspectFill
                    scene.childNode(withName: "leftPad")?.isHidden = true
                    scene.childNode(withName: "rightPad")?.isHidden = true
                    // Present the scene
                    view?.presentScene(scene)
                }
            } else {
                print("error")
            }
        }
    }
    
    

    

    
}
