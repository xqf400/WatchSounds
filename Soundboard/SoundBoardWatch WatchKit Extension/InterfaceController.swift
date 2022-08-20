//
//  InterfaceController.swift
//  SoundBoardWatch WatchKit Extension
//
//  Created by Fabian Kuschke on 19.01.22.
//

import WatchKit
import Foundation
import AVFoundation
import MediaPlayer

class InterfaceController: WKInterfaceController, AVAudioPlayerDelegate {
    
    @IBOutlet weak var tableView: WKInterfaceTable!
    var player: AVAudioPlayer?
    override func awake(withContext context: Any?) {
        print("awake")

    }
    
    override func willActivate() {
        print("willActivate")
        // This method is called when watch view controller is about to be visible to user
    }
    
    override func didDeactivate() {
        print("didDeactivate")
        // This method is called when watch view controller is no longer visible
    }

    @IBAction func playSound() {
        play()
    }
    
    func play(){
        guard let url = Bundle.main.url(forResource: "LaylaKurz", withExtension: "mp3") else { print("nil"); return }
        let volume = 1.0
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            player?.delegate = self
            player?.setVolume(Float(volume), fadeDuration: 10.0)
            //guard let player = player else { return }
            player!.play()
            print("played")
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
}
