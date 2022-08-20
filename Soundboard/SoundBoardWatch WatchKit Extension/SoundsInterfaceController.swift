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
    
    @IBOutlet weak var daysTillLabel: WKInterfaceLabel!
    @IBOutlet weak var stopButtonOutlet: WKInterfaceButton!
    @IBOutlet weak var tableView: WKInterfaceTable!
    
    var soundsNormal : [SoundModel] = []

    //MARK: awake
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        //showConsultingSounds = UserDefaults.standard.bool(forKey: "showConsultingSounds")
        settedDaysTill = UserDefaults.standard.integer(forKey: "settedDaysTill")
        addAllSound()
        tableView.setNumberOfRows(soundsNormal.count, withRowType: "SoundRow")
        for index in 0..<tableView.numberOfRows {
            guard let controller = tableView.rowController(at: index) as? SoundRow else { continue }
            guard let url = Bundle.main.url(forResource: soundsNormal[index].soundFile, withExtension: "mp3") else {
                print("File not found: \(soundsNormal[index].soundFile)")
                return}
            
            let audioDurationSeconds = CMTimeGetSeconds(AVURLAsset(url: url, options: nil).duration)
            let seconds = String(format: "%.1fs", audioDurationSeconds)
            controller.soundSeconds = seconds
            controller.sound = soundsNormal[index]
        }
        daysTillLabel.setText("\(settedDaysTill) Days ")

    }
    
    override func willActivate() {
        super.willActivate()

        let date = UserDefaults.standard.object(forKey: "selectedDate") as! Date
        let days = getDaysBetweenDates(from: Date(), to: date)
        settedDaysTill = days
        UserDefaults.standard.set(settedDaysTill, forKey: "settedDaysTill")
        
        daysTillLabel.setText("\(settedDaysTill) Days ")
    }
    
    //MARK: Table did Select
    override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
        play(sound: soundsNormal[rowIndex])
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
        
        soundsNormal.append(lollipop_kurz)
        soundsNormal.append(IDontcare)
        soundsNormal.append(mimimi)
        soundsNormal.append(tellmewhykurz)
        soundsNormal.append(vielleichtsekt)
        soundsNormal.append(lollipop_long)
        soundsNormal.append(lollipop1)
        soundsNormal.append(lollipop2)
        soundsNormal.append(lollipop_pop)
        soundsNormal.append(Iloveit)
        soundsNormal.append(EsTutMirLeidPocahontas)
        soundsNormal.append(IfYoureHappy)
        soundsNormal.append(denken)
        soundsNormal.append(excited_kurz)
        soundsNormal.append(JedeZelleKurz)
        soundsNormal.append(miracolikurz)
        soundsNormal.append(SchoenerTagStuttgarter)
        soundsNormal.append(Spass__kurz)
        soundsNormal.append(Tag__kurz)
        soundsNormal.append(tellmewhylang)
        soundsNormal.append(VerstehIchNichtKurz)
        soundsNormal.append(delfin)
        soundsNormal.append(esel)
        soundsNormal.append(gehdochzuhause)
        soundsNormal.append(HitMeBabyOneMoreTime)
        soundsNormal.append(imperialmarch)
        soundsNormal.append(jajalang)
        soundsNormal.append(jajakurz)
        soundsNormal.append(Mallezuruck)
        soundsNormal.append(wasmachensachen)
        soundsNormal.append(CantinaBand)
        soundsNormal.append(QuatschMerkschSelber)
        soundsNormal.append(Layla)
        soundsNormal.append(imperialmarchLong)
        
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
