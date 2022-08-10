//
//  InterfaceController.swift
//  WatchSoundsWatch WatchKit Extension
//
//  Created by Fabian Kuschke on 10.08.22.
//

import WatchKit
import Foundation
import AVFoundation
import MediaPlayer

var audioPlayer: AVAudioPlayer?

class SoundsInterfaceController: WKInterfaceController {
    
    @IBOutlet weak var tableView: WKInterfaceTable!
    var sounds : [SoundModel] = []

    override func awake(withContext context: Any?) {
        // Configure interface objects here.
        super.awake(withContext: context)
        getSounds()
        tableView.setNumberOfRows(sounds.count, withRowType: "SoundRow")
        for index in 0..<tableView.numberOfRows {
            guard let controller = tableView.rowController(at: index) as? SoundRow else { continue }
            guard let url = Bundle.main.url(forResource: sounds[index].soundFile, withExtension: "mp3") else {
                print("File not found: \(sounds[index].soundFile)")
                return}
            
            let audioDurationSeconds = CMTimeGetSeconds(AVURLAsset(url: url, options: nil).duration)
            let seconds = String(format: "%.1fs", audioDurationSeconds)
            controller.soundSeconds = seconds
            controller.sound = sounds[index]
        }

    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
    }
    
    private func getSounds(){
        sounds.removeAll()
        let Layla = SoundModel(soundId: 1, soundName: "Layla kurz", soundFile: "LaylaKurz")
        sounds.append(Layla)
        
    }
    
    //MARK: Table did Select
    override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
        let sound = sounds[rowIndex]
        guard let url = Bundle.main.url(forResource: sound.soundFile, withExtension: "mp3") else { print("nil"); return }
        play(sound: sound, url: url)
    }
    
    //MARK: Play Sound
    private func play(sound: SoundModel, url:URL){

        //stopButtonOutlet.setBackgroundImage(UIImage(systemName: "stop.fill"))
        let volume = 1.0
        //WKInterfaceVolumeControl.
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            
            audioPlayer = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            audioPlayer?.delegate = self
            audioPlayer?.setVolume(Float(volume), fadeDuration: 10.0)
            
            //guard let playerSave = audioPlayer else { return }
            //print("play \(playerSave.volume) and \(AVAudioSession.sharedInstance().outputVolume)")
            audioPlayer?.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }

}

//MARK: AVAudioPlayerDelegate
extension SoundsInterfaceController: AVAudioPlayerDelegate {
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            print("player finished")
            //stopButtonOutlet.setBackgroundImage(UIImage(systemName: "shuffle"))
        }
    }
}
