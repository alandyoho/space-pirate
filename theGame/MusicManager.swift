//
//  MusicManager.swift
//  theGame
//
//  Created by Alan D. Yoho on 4/26/18.
//  Copyright © 2018 Alan D. Yoho. All rights reserved.
//

import Foundation
import SpriteKit


class MusicManager {
    let loop = SKAudioNode(fileNamed: "music.mp3")
    let play = SKAction.play()
    let pause = SKAction.pause()
    var isPlaying = Bool()

}
