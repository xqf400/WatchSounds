//
//  SoundRow.swift
//  SoundBoardWatch WatchKit Extension
//
//  Created by Fabian Kuschke on 19.01.22.
//

import WatchKit
import UIKit

class SoundRow : NSObject {
    
    @IBOutlet weak var soundLength: WKInterfaceLabel!
    @IBOutlet weak var labelSound: WKInterfaceLabel!
    @IBOutlet weak var imageSound: WKInterfaceImage!
    var soundSeconds: String?
    var sound: SoundModel? {
      didSet {
          labelSound.setText("\(sound!.soundName) \(soundSeconds!)")
          if sound!.soundImage == "NoName"{
              imageSound.setImage(UIImage(systemName: "music.note"))
          }else{
              imageSound.setImage(UIImage(named: sound!.soundImage))
          }
          //soundLength.setText(soundSeconds)
      }
    }
}
