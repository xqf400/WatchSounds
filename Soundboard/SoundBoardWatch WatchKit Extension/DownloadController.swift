//
//  DownloadController.swift
//  SoundBoardWatch WatchKit Extension
//
//  Created by Fabian Kuschke on 20.08.22.
//

import Foundation
import WatchKit
import RNCryptor

class DownloadController: WKInterfaceController {
    
    @IBOutlet weak var testLabel: WKInterfaceLabel!
    @IBOutlet weak var volumeView: WKInterfaceVolumeControl!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        volumeView.focus()
        testLabel.setText("Test")
    }
    
    override func willDisappear() {
        volumeView.resignFocus()
    }
    
    override func willActivate() {
        super.willActivate()
    }
    
    @IBAction func downloadButtonAction() {
        print("pressed")
    }
}
