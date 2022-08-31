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
        createFolder()
        addAllSound()
        /*
        addAllSound()
        tableView.setNumberOfRows(soundsNormal.count, withRowType: "SoundRow")
        for index in 0..<tableView.numberOfRows {
            guard let controller = tableView.rowController(at: index) as? SoundRow else { continue }
            let audioDurationSeconds = CMTimeGetSeconds(AVURLAsset(url: soundsNormal[index].soundFileURL, options: nil).duration)
            let seconds = String(format: "%.1fs", audioDurationSeconds)
            controller.soundSeconds = seconds
            controller.sound = soundsNormal[index]
        }*/


    }
    
    override func willActivate() {
        super.willActivate()
        addAllSound()

    }
    
    private func createFolder(){
        if let libraryDirectoryURL5 = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).first{
            let subfolder5 = libraryDirectoryURL5.appendingPathComponent("Soundfiles")
            do {
                try FileManager.default.createDirectory(at: subfolder5, withIntermediateDirectories: false, attributes: nil)
                print("Here directory created")
            }
            catch let error as NSError {
                if error.code == 516 {
                    //myDebug("Here The directory already exists")
                } else {
                    print("directory createt error: \(error)")
                }
            }
        }
    }
    
    //MARK: Table did Select
    override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
        play(sound: soundsNormal[rowIndex])
    }
    
    //MARK: Play Sound
    func play(sound: SoundModel){

        let volume = 1.0

        let localURL = soundsURL.appendingPathComponent(sound.soundFile)
            do {
                try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
                try AVAudioSession.sharedInstance().setActive(true)
                playerOrg = try AVAudioPlayer(contentsOf: localURL, fileTypeHint: AVFileType.mp3.rawValue)
                playerOrg?.delegate = self
                playerOrg?.setVolume(Float(volume), fadeDuration: 10.0)
                
                guard let playerSave = playerOrg else {
                    print("player else")
                    return
                }
                stopButtonOutlet.setBackgroundImage(UIImage(systemName: "stop.fill"))
                playerSave.play()
            } catch let error {
                print("Error X: \(error.localizedDescription)")
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
        //getLocalFiles()
        if UserDefaults.standard.string(forKey: "adress") != nil{
        getSoundFromFiles { str in
            self.tableView.setNumberOfRows(soundsNormal.count, withRowType: "SoundRow")
            for index in 0..<self.tableView.numberOfRows {
                guard let controller = self.tableView.rowController(at: index) as? SoundRow else { continue }
                
                let audioDurationSeconds = CMTimeGetSeconds(AVURLAsset(url: soundsURL.appendingPathComponent(soundsNormal[index].soundFile), options: nil).duration)
                let seconds = String(format: "%.1fs", audioDurationSeconds)
                controller.soundSeconds = seconds
                controller.sound = soundsNormal[index]
            }
        } failure: { error in
            print(error)
        }


        //soundsNormal.append(Layla)
        soundsNormal = soundsNormal.sorted { $0.soundName < $1.soundName }
        }
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
