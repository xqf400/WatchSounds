//
//  VolumeViewController.swift
//  WatchSoundsWatch WatchKit Extension
//
//  Created by Fabian Kuschke on 10.08.22.
//

import WatchKit
import Foundation
import AVFoundation

class VolumeInterfaceController: WKInterfaceController {
    @IBOutlet weak var volumeView: WKInterfaceVolumeControl!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        volumeView.focus()
    }
    override func willDisappear() {
        volumeView.resignFocus()
    }
    
    override func willActivate() {
        super.willActivate()
    }
}
