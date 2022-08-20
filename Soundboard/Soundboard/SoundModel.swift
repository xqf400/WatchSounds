//
//  SoundModel.swift
//  Soundboard
//
//  Created by Fabian Kuschke on 07.11.21.
//

import UIKit

class SoundModel:Codable{
    
    var soundId : Int
    var soundName : String
    var soundImage : String
    var soundFile : String
    var soundVolume : Float

    
    init(soundId: Int, soundName: String, soundImage: String, soundFile: String, soundVolume: Float) {
        self.soundId = soundId
        self.soundName = soundName
        self.soundImage = soundImage
        self.soundFile = soundFile
        self.soundVolume = soundVolume
    }
    
    
}
