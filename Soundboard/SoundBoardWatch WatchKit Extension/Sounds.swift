//
//  Sounds.swift
//  SoundBoardWatch WatchKit Extension
//
//  Created by Fabian Kuschke on 12.04.22.
//

import Foundation
import MediaPlayer

let soundVolume:Float = 1
var playerOrg: AVAudioPlayer?
var settedDaysTill : Int = 0

let url = Bundle.main.url(forResource: "LaylaKurz", withExtension: "mp3")!
let Layla = SoundModel(soundId: 55, soundName: "Layla kurz", soundImage: "Layla.png", soundFile: "LaylaKurz", soundVolume: soundVolume, soundFileURL: url)


