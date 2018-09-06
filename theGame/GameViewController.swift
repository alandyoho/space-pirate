//
//  GameViewController.swift
//  theGame
//
//  Created by Alan D. Yoho on 4/23/18.
//  Copyright © 2018 Alan D. Yoho. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    @IBOutlet weak var gameImageView: UIImageView!
    
    @IBOutlet weak var startGameImageView: UIImageView!
    
    @IBOutlet weak var countdownImageButton: UIImageView!
    @IBOutlet weak var startGameButton: UIButton!
    static var startGame = false
    static var health = 10
    
    @IBAction func startGameButtonPressed(_ sender: Any) {
        UIView.animate(withDuration: 0.5, animations: {
            self.gameImageView.alpha = 0.0
            self.startGameImageView.alpha = 0.0
            self.startGameButton.isEnabled = false
            GameViewController.startGame = true
            
            let imageArray: [UIImage] = [UIImage(named: "empty")!, UIImage(named: "3")!, UIImage(named: "2")!, UIImage(named: "1")!]
            self.countdownImageButton?.animationImages = imageArray
            self.countdownImageButton?.animationDuration = 1.5
            self.countdownImageButton.animationRepeatCount = 1
            self.countdownImageButton.contentScaleFactor = 0.5
            self.countdownImageButton?.startAnimating()
        })
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imageArray: [UIImage] = [UIImage(named: "spacePirate_blue")!, UIImage(named: "spacePirate_red")!, UIImage(named: "spacePirate_darkBlue")!]
        
        gameImageView?.animationImages = imageArray
        gameImageView?.animationDuration = 1.5
        gameImageView?.startAnimating()
        
        
        
        let startGameImageArray: [UIImage] = [UIImage(named: "startGame_blue")!, UIImage(named: "startGame_red")!, UIImage(named: "startGame_darkBlue")!]
        let startImageView = startGameImageView
        startImageView?.animationImages = startGameImageArray
        startImageView?.animationDuration = 1.5
        startImageView?.startAnimating()
        
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                scene.childNode(withName: "leftPad")?.isHidden = true
                scene.childNode(withName: "rightPad")?.isHidden = true
                

                // Present the scene
                view.presentScene(scene)
            }
            
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
        

    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
