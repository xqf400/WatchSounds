//
//  SoundRow.swift
//  WatchSoundsWatch WatchKit Extension
//
//  Created by Fabian Kuschke on 10.08.22.
//

import WatchKit

class SoundRow : NSObject {
    
    @IBOutlet weak var nameLabel: WKInterfaceLabel!
    var soundSeconds: String?
    var sound: SoundModel? {
      didSet {
          nameLabel.setText("\(sound!.soundName) \(soundSeconds!)")
          //imageSound.setImage(UIImage(named: sound!.soundImage))
          //soundLength.setText(soundSeconds)
      }
    }
}
