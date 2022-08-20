//
//  DownloadController.swift
//  SoundBoardWatch WatchKit Extension
//
//  Created by Fabian Kuschke on 20.08.22.
//

import Foundation
import WatchKit
import RNCryptor
import Alamofire

class DownloadController: WKInterfaceController {
    
    @IBOutlet weak var testLabel: WKInterfaceLabel!
    @IBOutlet weak var volumeView: WKInterfaceVolumeControl!
    

    var session : URLSession!
    
    override func awake(withContext context: Any?) {
        session = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: OperationQueue())
        super.awake(withContext: context)
        //UserDefaults.standard.set("8header8@googlemail.com", forKey: "adress")
        
        volumeView.focus()
        setLabel()

    }
    
    override func willDisappear() {
        volumeView.resignFocus()
    }
    
    override func willActivate() {
        super.willActivate()
    }
    
    @IBAction func downloadButtonAction() {
        
        //let songName = "esel.mp3"
        //downloadSong(name: songName)
        DispatchQueue.main.async {
            self.testLabel.setText("loading...")
        }
        if UserDefaults.standard.string(forKey: "adress") != nil{
            let mail = UserDefaults.standard.string(forKey: "adress")
            downloadDataFromFireBase(name: "\(mail!).plist", folder: "userLists", session: session) { data in
                print("downloaded plist")
                decodeClipFromData(data: data) { user in
                    print("decoded")
                    var count = 0
                    for sound in user.sounds{
                        let soundX = sound
                        downloadMp3FromFireBase(mp3Name: soundX.soundFile, session: self.session) { url in
                            soundX.soundFileURL = url
                            print("Sound: \(soundX.soundName) \nURL: \(soundX.soundFileURL) \nFile: \(sound.soundFile)")
                            if soundsNormal.first(where: { $0.soundFile == soundX.soundFile }) != nil {
                                print("already in")
                            }else{
                                soundsNormal.append(soundX)
                            }
                            count += 1
                            if count == user.sounds.count{
                                writeArrayToFiles()
                                DispatchQueue.main.async {
                                    self.testLabel.setText("Downloaded")
                                }
                            }
                        } failure: { error in
                            print("Error download mp3 \(error)")
                            count += 1
                            if count == user.sounds.count{
                                writeArrayToFiles()
                                DispatchQueue.main.async {
                                    self.testLabel.setText("Downloaded")
                                }
                            }
                        }
                    }
                } failure: { error in
                    print("Error 325 \(error)")
                    DispatchQueue.main.async {
                        self.testLabel.setText("Error")
                    }
                }
            } failure: { error in
                print("Error 67 \(error)")
                DispatchQueue.main.async {
                    self.testLabel.setText("Error")
                }
            }
        }else{
            print("Mail empty")
            DispatchQueue.main.async {
                self.testLabel.setText("Please syncronise mail empty")
            }
        }        
    }
    

    

    
    private func setLabel(){
        if UserDefaults.standard.string(forKey: "adress") != nil{
            DispatchQueue.main.async {
                let adress = UserDefaults.standard.string(forKey: "adress")
                self.testLabel.setText("Mail: \(adress!)")
            }
        }else{
            DispatchQueue.main.async {
                self.testLabel.setText("Mail is empty")
            }
        }
    }

    
    
    
    
   
    
    
}//eoc

extension DownloadController: URLSessionDelegate {
    
    
    // MARK: protocol stub for tracking download progress
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
            
        let percentDownloaded = totalBytesWritten / totalBytesExpectedToWrite
            
        // update the percentage label
        //DispatchQueue.main.async {
            print("\(percentDownloaded * 100)%")
        //}
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
            
        print("finished download \(location)")
    }
    
}
