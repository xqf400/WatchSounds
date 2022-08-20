//
//  ConsultinSounds.swift
//  SoundBoardWatch WatchKit Extension
//
//  Created by Fabian Kuschke on 27.04.22.
//

import Foundation
import WatchKit
import Foundation
import AVFoundation
import MediaPlayer


class ConsultingSoundsController: WKInterfaceController {
    
    @IBOutlet weak var daysTillLabel: WKInterfaceLabel!
    @IBOutlet weak var stopButtonOutlet: WKInterfaceButton!
    @IBOutlet weak var tableView: WKInterfaceTable!
    
    var soundsCon : [SoundModel] = []
    
    //MARK: awake
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        settedDaysTill = UserDefaults.standard.integer(forKey: "settedDaysTill")
        addAllSound()
        tableView.setNumberOfRows(soundsCon.count, withRowType: "SoundRow")
        for index in 0..<tableView.numberOfRows {
            guard let controller = tableView.rowController(at: index) as? SoundRow else { continue }
            guard let url = Bundle.main.url(forResource: soundsCon[index].soundFile, withExtension: "mp3") else {
                print("File not found: \(soundsCon[index].soundFile)")
                return}
            
            let audioDurationSeconds = CMTimeGetSeconds(AVURLAsset(url: url, options: nil).duration)
            let seconds = String(format: "%.1fs", audioDurationSeconds)
            controller.soundSeconds = seconds
            controller.sound = soundsCon[index]
        }
        daysTillLabel.setText("\(settedDaysTill) D.")
 
    }
    
    override func willActivate() {
        super.willActivate()

        let date = UserDefaults.standard.object(forKey: "selectedDate") as! Date
        let days = getDaysBetweenDates(from: Date(), to: date)
        settedDaysTill = days
        UserDefaults.standard.set(settedDaysTill, forKey: "settedDaysTill")
        
        daysTillLabel.setText("\(settedDaysTill) D.")
    }
    
    //MARK: Table did Select
    override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
        play(sound: soundsCon[rowIndex])
    }
    
    //MARK: Play Sound
    func play(sound: SoundModel){
        
        guard let url = Bundle.main.url(forResource: sound.soundFile, withExtension: "mp3") else { print("nil"); return }
        stopButtonOutlet.setBackgroundImage(UIImage(systemName: "stop.fill"))
        let volume = 1.0
        //WKInterfaceVolumeControl.
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            
            playerOrg = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            playerOrg?.delegate = self
            playerOrg?.setVolume(Float(volume), fadeDuration: 10.0)
            
            guard let playerSave = playerOrg else { return }

            //print("play \(playerSave.volume) and \(AVAudioSession.sharedInstance().outputVolume)")
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
                
                play(sound: soundsCon.randomElement()!)
            }
        }else{
            stopButtonOutlet.setBackgroundImage(UIImage(systemName: "stop.fill"))
            play(sound: soundsCon.randomElement()!)
        }
    }
    
    
    //MARK: Add all sounds
    func addAllSound(){
        soundsCon.removeAll()
        
        soundsCon.append(mse_richtig)
        soundsCon.append(mse_wunderbar)
        soundsCon.append(mse_guuuut)
        soundsCon.append(nlu_danke)
        soundsCon.append(nlu_haha)
        soundsCon.append(mse_richtig)
        soundsCon.append(mse_wunderbar)
        soundsCon.append(MSE_Die_Katze_im_Sack)
        soundsCon.append(nlu_meeting)
        soundsCon.append(mse_NochFragen)
        soundsCon.append(mse_3)
        soundsCon.append(nlu_am_montag_passiert)
        soundsCon.append(nlu_alles_nicht_so_dramatisch)
        soundsCon.append(nlu_tututu)
        soundsCon.append(mse_dann_mach_mer_des_doch_so)
        soundsCon.append(smartMatze)
        soundsCon.append(MSE_Und_ich_sag_aber_ok)
        soundsCon.append(halloPascalkurz)
        
    }
    
    
}

//MARK: AVAudioPlayerDelegate
extension ConsultingSoundsController: AVAudioPlayerDelegate {
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            //print("player finished")
            stopButtonOutlet.setBackgroundImage(UIImage(systemName: "shuffle"))
        }
    }
}

