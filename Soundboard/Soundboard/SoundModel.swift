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
    var showOnLS : Bool
    //var soundFileURL: URL

    
    init(soundId: Int, soundName: String, soundImage: String, soundFile: String, soundVolume: Float, showOnLS: Bool) {
        self.soundId = soundId
        self.soundName = soundName
        self.soundImage = soundImage
        self.soundFile = soundFile
        self.soundVolume = soundVolume
        self.showOnLS = showOnLS
        //self.soundFileURL = soundFileURL
    }
    
    func print(){
        Swift.print("")
        Swift.print("soundId: \(self.soundId)")
        Swift.print("soundName: \(self.soundName)")
        Swift.print("soundImage: \(self.soundImage)")
        Swift.print("soundFile: \(self.soundFile)")
        Swift.print("soundVolume: \(self.soundVolume)")
        Swift.print("showOnLS: \(self.showOnLS)")
        Swift.print("")


    }
    
    
}
