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
import WatchConnectivity
let cloudManager = CloudDataManager()

var audioPlayer: AVAudioPlayer?

class SoundsInterfaceController: WKInterfaceController, WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if error != nil {
            print(error!)
        }
        print("Session: ", session.applicationContext)
    }
    func session(_ session: WCSession, didReceiveMessageData messageData: Data) {
        print("got message")

        guard let image = UIImage(data: messageData) else {
            return
        }
        DispatchQueue.main.async{
            self.topLeftImageView.setImage(image)
        }

    }
    func session(_ session: WCSession, didReceiveMessageData messageData: Data, replyHandler: @escaping (Data) -> Void) {
        print("got message")
        guard let image = UIImage(data: messageData) else {
            return
        }
        DispatchQueue.main.async{
            self.topLeftImageView.setImage(image)
        }
        //WKInterfaceDevice.current().play(.notification)
    }
//    func session(session: WCSession, didReceiveMessageData messageData: NSData, replyHandler: (NSData) -> Void) {
//print("got message")
//        guard let image = UIImage(data: messageData) else {
//            return
//        }
//
//        // throw to the main queue to upate properly
//        dispatch_async(dispatch_get_main_queue()) { [weak self] in
//            // update your UI here
//        }
//
//       replyHandler(messageData)
//    }
    
    
    @IBOutlet weak var topLeftImageView: WKInterfaceImage!
    @IBOutlet weak var soundsLabel: WKInterfaceLabel!
    @IBOutlet weak var tableView: WKInterfaceTable!
    var sounds : [SoundModel] = []
    //let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.fku.watchSounds.SharingData")
    //var userDefaults = UserDefaults.init(suiteName: "group.fku.watchSounds.SharingData")
    
    


    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
//        userDefaults!.set("Testwatch", forKey: "testwatch")
//        userDefaults!.synchronize()
//        soundsLabel.setText("Test: \(userDefaults!.string(forKey: "testphone"))")

        if WCSession.isSupported() {
            WCSession.default.delegate = self
            WCSession.default.activate()
        }
        
        let driveURL = FileManager.default.url(forUbiquityContainerIdentifier: nil)?.appendingPathComponent("Documents")
            if let unwrappedFU = driveURL {
                print("iCloud available")
            } else {
                print("iCloud not available")
            }

        getSounds()
        getAllOnlineFiles()
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
    
    
    private func getAllOnlineFiles(){
        if cloudManager.isCloudEnabled() {
            let url = CloudDataManager.sharedInstance.getDocumentDiretoryURL()
            print("icloud works")
            //cloudManager.enableCloudExample()
            let tempURL = url
            //print(tempURL)
            do {
                let directoryContents = try FileManager.default.contentsOfDirectory(at: tempURL, includingPropertiesForKeys: nil)
                //print("directoryContents:", directoryContents.map { $0.localizedName ?? $0.lastPathComponent })
                for url1 in directoryContents {
                    print(url1.localizedName ?? url1.lastPathComponent)
                }
                
                // if you would like to hide the file extension
                //                    for var url in directoryContents {
                //                        url.hasHiddenExtension = true
                //                    }
                //                    for url in directoryContents {
                //                        print(url.localizedName ?? url.lastPathComponent)
                //                    }
                // if you want to get all mp3 files located at the documents directory:
                let mp3s = directoryContents.filter(\.isMP3).map { $0.localizedName ?? $0.lastPathComponent }
                print("mp3s:", mp3s)
                for mp3File in mp3s {
                    //names.append(mp3File)
                }
            } catch {
                print(error)
            }
        }else{
            print("enable cloud")
        }
    }
    
    private func getSounds(){
        sounds.removeAll()
        let Layla = SoundModel(soundId: 1, soundName: "Layla kurz", soundFile: "LaylaKurz")
        sounds.append(Layla)
        
//        do {
//            let directoryContents = try FileManager.default.contentsOfDirectory(at: url!, includingPropertiesForKeys: nil)
//            //print("directoryContents:", directoryContents.map { $0.localizedName ?? $0.lastPathComponent })
//            for url1 in directoryContents {
//                print(url1.localizedName ?? url1.lastPathComponent)
//            }
//            
//            // if you would like to hide the file extension
//            for var url in directoryContents {
//                url.hasHiddenExtension = true
//            }
//            for url in directoryContents {
//                print(url.localizedName ?? url.lastPathComponent)
//            }
//            // if you want to get all mp3 files located at the documents directory:
//            let mp3s = directoryContents.filter(\.isMP3).map { $0.localizedName ?? $0.lastPathComponent }
//            print("mp3s:", mp3s)
//        } catch {
//            print(error)
//        }
        
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

extension URL {
    var typeIdentifier: String? { (try? resourceValues(forKeys: [.typeIdentifierKey]))?.typeIdentifier }
    var isMP3: Bool { typeIdentifier == "public.mp3" }
    var localizedName: String? { (try? resourceValues(forKeys: [.localizedNameKey]))?.localizedName }
    var hasHiddenExtension: Bool {
        get { (try? resourceValues(forKeys: [.hasHiddenExtensionKey]))?.hasHiddenExtension == true }
        set {
            var resourceValues = URLResourceValues()
            resourceValues.hasHiddenExtension = newValue
            try? setResourceValues(resourceValues)
        }
    }
}
