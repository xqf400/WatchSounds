//
//  SoundsInterfaceController.swift
//  SoundBoardWatch WatchKit Extension
//
//  Created by Fabian Kuschke on 19.01.22.
//

import WatchKit
import Foundation
import AVFoundation
import MediaPlayer


//MARK: to check
//https://www.raywenderlich.com/2101-video-tutorial-watchkit-part-12-sharing-data

class SoundsInterfaceController: WKInterfaceController {
    
    @IBOutlet weak var stopButtonOutlet: WKInterfaceButton!
    @IBOutlet weak var tableView: WKInterfaceTable!
    


    //MARK: awake
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        addAllSound()
        tableView.setNumberOfRows(soundsNormal.count, withRowType: "SoundRow")
        for index in 0..<tableView.numberOfRows {
            guard let controller = tableView.rowController(at: index) as? SoundRow else { continue }
            let audioDurationSeconds = CMTimeGetSeconds(AVURLAsset(url: soundsNormal[index].soundFileURL, options: nil).duration)
            let seconds = String(format: "%.1fs", audioDurationSeconds)
            controller.soundSeconds = seconds
            controller.sound = soundsNormal[index]
        }


    }
    
    override func willActivate() {
        super.willActivate()
        addAllSound()
        tableView.setNumberOfRows(soundsNormal.count, withRowType: "SoundRow")
        for index in 0..<tableView.numberOfRows {
            guard let controller = tableView.rowController(at: index) as? SoundRow else { continue }
            let audioDurationSeconds = CMTimeGetSeconds(AVURLAsset(url: soundsNormal[index].soundFileURL, options: nil).duration)
            let seconds = String(format: "%.1fs", audioDurationSeconds)
            controller.soundSeconds = seconds
            controller.sound = soundsNormal[index]
        }
    }
    
    //MARK: Table did Select
    override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
        play(sound: soundsNormal[rowIndex])
    }
    
    //MARK: Play Sound
    func play(sound: SoundModel){

        stopButtonOutlet.setBackgroundImage(UIImage(systemName: "stop.fill"))
        let volume = 1.0
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            
            playerOrg = try AVAudioPlayer(contentsOf: sound.soundFileURL, fileTypeHint: AVFileType.mp3.rawValue)
            playerOrg?.delegate = self
            playerOrg?.setVolume(Float(volume), fadeDuration: 10.0)
            
            guard let playerSave = playerOrg else { return }

            playerSave.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    //MARK: Stop/Random Button Action
    @IBAction func stopButtonAction() {
        if playerOrg != nil {
            if playerOrg!.isPlaying{
                playerOrg!.pause()
                stopButtonOutlet.setBackgroundImage(UIImage(systemName: "shuffle"))//setBackgroundImage(UIImage(named: "shuffle"))
            }else{
                stopButtonOutlet.setBackgroundImage(UIImage(systemName: "stop.fill"))//setBackgroundImage(UIImage(named: "stop.fill"))
                play(sound: soundsNormal.randomElement()!)
            }
        }else{
            stopButtonOutlet.setBackgroundImage(UIImage(systemName: "stop.fill"))
            play(sound: soundsNormal.randomElement()!)
        }
    }

    
    //MARK: Add all sounds
    func addAllSound(){
        soundsNormal.removeAll()
        getLocalFiles()

        soundsNormal.append(Layla)
        soundsNormal = soundsNormal.sorted { $0.soundName < $1.soundName }
    }
    
    
}

//MARK: AVAudioPlayerDelegate
extension SoundsInterfaceController: AVAudioPlayerDelegate {
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            //print("player finished")
            stopButtonOutlet.setBackgroundImage(UIImage(systemName: "shuffle"))
        }
    }
}
