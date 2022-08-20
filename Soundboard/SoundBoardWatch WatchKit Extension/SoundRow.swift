//
//  SoundRow.swift
//  SoundBoardWatch WatchKit Extension
//
//  Created by Fabian Kuschke on 19.01.22.
//

import WatchKit

class SoundRow : NSObject {
    
    @IBOutlet weak var soundLength: WKInterfaceLabel!
    @IBOutlet weak var labelSound: WKInterfaceLabel!
    @IBOutlet weak var imageSound: WKInterfaceImage!
    var soundSeconds: String?
    var sound: SoundModel? {
      didSet {
          labelSound.setText("\(sound!.soundName) \(soundSeconds!)")
          imageSound.setImage(UIImage(named: sound!.soundImage))
          //soundLength.setText(soundSeconds)
      }
    }
}
