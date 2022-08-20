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
        createFolder()
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
        
        if UserDefaults.standard.string(forKey: "adress") != nil{
            let mail = UserDefaults.standard.string(forKey: "adress")
            downloadDataFromFireBase(name: "\(mail!).plist", folder: "userLists", session: session) { data in
                print("downloaded plist")
                decodeClipFromData(data: data) { user in
                    print("decoded \(user.mail)")
                    for soundName in user.sounds{
                        print("Sound: \(soundName)")
                        self.downloadSong(name: soundName)
                    }
                } failure: { error in
                    print("Error 325 \(error)")
                }
            } failure: { error in
                print("Error 67 \(error)")
            }
        }else{
            print("Mail empty")
            DispatchQueue.main.async {
                self.testLabel.setText("Please syncronise mail empty")
            }
        }
        
        
    }
    
    private func downloadSong(name:String){
        downloadMp3FromFireBase(mp3Name: name, session: session) { url in
            print(url)
        } failure: { error in
            print("Error download mp3 \(error)")
        }
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
