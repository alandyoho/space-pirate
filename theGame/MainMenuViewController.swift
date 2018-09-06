//
//  MainMenuViewController.swift
//  theGame
//
//  Created by Alan D. Yoho on 4/25/18.
//  Copyright © 2018 Alan D. Yoho. All rights reserved.
//

import UIKit

class MainMenuViewController: UIViewController {
    @IBOutlet weak var spacePirateImageView: UIImageView!
    
    @IBOutlet weak var startGameImageView: UIImageView!
    
    @IBOutlet weak var startGameButton: UIButton!
    
    @IBAction func startGameButtonPressed(_ sender: Any) {
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let imageArray: [UIImage] = [UIImage(named: "spacePirate_blue")!, UIImage(named: "spacePirate_red")!, UIImage(named: "spacePirate_darkBlue")!]
        let imageView = spacePirateImageView
        imageView?.animationImages = imageArray
        imageView?.animationDuration = 1.5
        imageView?.startAnimating()
        
        let startGameImageArray: [UIImage] = [UIImage(named: "startGame_blue")!, UIImage(named: "startGame_red")!, UIImage(named: "startGame_darkBlue")!]
        let gameImageView = startGameImageView
        gameImageView?.animationImages = startGameImageArray
        gameImageView?.animationDuration = 1.5
        gameImageView?.startAnimating()

                // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
