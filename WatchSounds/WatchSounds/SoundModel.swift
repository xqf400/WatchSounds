//
//  SoundModel.swift
//  WatchSounds
//
//  Created by Fabian Kuschke on 10.08.22.
//

import Foundation

class SoundModel:Codable{
    
    var soundId : Int
    var soundName : String
    var soundFile : String

    
    init(soundId: Int, soundName: String, soundFile: String) {
        self.soundId = soundId
        self.soundName = soundName
        self.soundFile = soundFile
    }
    
    
}
