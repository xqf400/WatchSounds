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
//import WatchConnectivity
import CoreData



class DownloadController: WKInterfaceController {
    
    @IBOutlet weak var testLabel: WKInterfaceLabel!
    @IBOutlet weak var volumeView: WKInterfaceVolumeControl!
    

    var session : URLSession!
    //var wcsession : WCSession?
    private var infoUserNS :[NSManagedObject] = []
    private var soundsNS :[NSManagedObject] = []
    

    
    override func awake(withContext context: Any?) {
        session = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: OperationQueue())
        super.awake(withContext: context)
        //UserDefaults.standard.set("8header8@googlemail.com", forKey: "adress")
        volumeView.focus()
        
        
        //online Cloud data
        
        guard let appDelegate = WKExtension.shared().delegate as? ExtensionDelegate else {
            print("not found")
            return
        }

        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest1 = NSFetchRequest<NSManagedObject>(entityName: "Sounds")
        //print("Fetch \(fetchRequest)")
        
        do {
            soundsNS = try managedContext.fetch(fetchRequest1)
            //print("Info: \(soundsNS)")
            for sound in soundsNS {
                let soundId = (sound.value(forKeyPath: "soundId") as! Int)
                let soundName = (sound.value(forKeyPath: "soundName") as! String)
                let soundImage = (sound.value(forKeyPath: "soundImage") as! String)
                let soundFile = (sound.value(forKeyPath: "soundFile") as! String)
                let soundVolume = (sound.value(forKeyPath: "soundVolume") as! Float)
                
                let sound = SoundModel(soundId: soundId, soundName: soundName, soundImage: soundImage, soundFile: soundFile, soundVolume: soundVolume)
                sound.print()
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "UserI")

        do {
            infoUserNS = try managedContext.fetch(fetchRequest)
            //print("Info: \(infoUserNS)")
            for info in infoUserNS {
                let mail = (info.value(forKeyPath: "mail") as! String)
                let id = (info.value(forKeyPath: "id") as! Int)
                let maxFilesCount = (info.value(forKeyPath: "maxFilesCount") as! Int)
                let uploadedSoundsCount = (info.value(forKeyPath: "uploadedSoundsCount") as! Int)
                let secret = (info.value(forKeyPath: "secret") as! String)
                let creationDate = (info.value(forKeyPath: "creationDate") as! String)
                
                print("mail: \(mail)")
                //UserDefaults.standard.set("8header8@googlemail.com", forKey: "adress")
                let user = User(id: id, mail: mail, maxFilesCount: maxFilesCount, uploadedSoundsCount: uploadedSoundsCount, secret: secret, sounds: [], creationDate: creationDate)
                user.print()
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }

    }
    
    override func willDisappear() {
        volumeView.resignFocus()
    }
    
    override func willActivate() {
        super.willActivate()
        setLabel()
        /*
        if WCSession.isSupported() {
            wcsession = WCSession.default
            wcsession!.delegate = self
            wcsession!.activate()
            print("startet wc session")
        }*/
    }
    
    @IBAction func downloadButtonAction() {
        
        
        /*
         guard let appDelegate = WKExtension.shared().delegate as? ExtensionDelegate else {
             print("not found")
             return
         }
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Userinfo", in: managedContext)!
        let soundObject = NSManagedObject(entity: entity, insertInto: managedContext)
        soundObject.setValue(adress, forKeyPath: "mail")

        do {
            try managedContext.save()
            infoUser.append(soundObject)
            print("suc database")
            appDelegate.saveDatabase()
        } catch let error as NSError {
            print("Could not save. \(error)")
        }*/
        
        
        
        DispatchQueue.main.async {
            self.testLabel.setText("loading...")
        }
        if UserDefaults.standard.string(forKey: "adress") != nil{
            let mail = UserDefaults.standard.string(forKey: "adress")
            downloadDataFromFireBase(name: "\(mail!).plist", folder: "userLists", session: session) { data in
                print("downloaded plist")
                decodeClipFromData(data: data) { user in
                    print("decoded todo check if secret is same as this : \(user.user.secret)")
                    //UserDefaults.standard.set(user.secret, forKey: "secret")
                    var count = 0
                    for sound in user.sounds{
                        let soundX = sound
                        downloadMp3FromFireBase(mp3Name: soundX.soundFile, session: self.session) { url in
                            //soundX.soundFileURL = url
                            print("Sound: \(soundX.soundName) \nURL: \(soundX.soundName) \nFile: \(sound.soundFile)")
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
                                    let action = WKAlertAction(title: "Ok", style: WKAlertActionStyle.default) {
                                            print("Ok")
                                        }
                                    self.presentAlert(withTitle: "Downloaded", message: "Downloaded sounds", preferredStyle: WKAlertControllerStyle.alert, actions:[action])
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

    
//    private func sendToiPhone() {
//        let data: [String: Any] = ["watch": "got data" as Any]
//        wcsession.sendMessage(data, replyHandler: nil, errorHandler: nil)
//      }
    
    
   
    
    
}//eoc

//MARK: URL Session
extension DownloadController: URLSessionDelegate {
    
    
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

/*
extension DownloadController: WCSessionDelegate {
  
  
  func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
    
    print("received data: \(message)")
    if let value = message["mail"] as? String {
        DispatchQueue.main.async {
            self.testLabel.setText(value)
        }
    }
  }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if error != nil {
            print("error: \(error!)")
        }
    }
    func session(_ session: WCSession, didFinish fileTransfer: WCSessionFileTransfer, error: Error?) {
        print("Got file \(fileTransfer)")
        //WKInterfaceDevice.current().play(.notification)
    }
    func session(_ session: WCSession, didReceiveMessageData messageData: Data, replyHandler: @escaping (Data) -> Void) {
        print("got message")

        //WKInterfaceDevice.current().play(.notification)
    }
    func session(_ session: WCSession, didReceive file: WCSessionFile) {
        print("file? \(file)")
        //WKInterfaceDevice.current().play(.notification)

    }

    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        print("applic \(applicationContext)")
        WKInterfaceDevice.current().play(.notification)
        //WKInterfaceDevice.current().play(.notification)
    }
    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String : Any] = [:]) {
        print("userinfo")
        //WKInterfaceDevice.current().play(.notification)
    }
    func sessionReachabilityDidChange(_ session: WCSession) {
        print("session isReachable \(session.isReachable)")
        print("session applicationContext \(session.applicationContext)")
        print("session hasContentPending \(session.hasContentPending)")
        print("session receivedApplicationContext \(session.receivedApplicationContext)")
        print("session isCompanionAppInstalled \(session.isCompanionAppInstalled)")
    }
    func session(_ session: WCSession, didFinish userInfoTransfer: WCSessionUserInfoTransfer, error: Error?) {
        print("userinfo")
       // WKInterfaceDevice.current().play(.notification)
    }
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        print("message: \(message)")
        WKInterfaceDevice.current().play(.notification)
        //if let msg = message["mail"] {
        //}
    }
    func session(_ session: WCSession, didReceiveMessageData messageData: Data) {
        print("daa \(messageData)")
        //WKInterfaceDevice.current().play(.notification)

    }
    
    
    
}//end
*/


