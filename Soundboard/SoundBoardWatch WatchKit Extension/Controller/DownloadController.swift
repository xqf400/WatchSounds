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
import CloudKit



class DownloadController: WKInterfaceController {
    
    @IBOutlet weak var testLabel: WKInterfaceLabel!
    @IBOutlet weak var volumeView: WKInterfaceVolumeControl!
    

    var session : URLSession!
    //var wcsession : WCSession?
    private var infoUserNS :[NSManagedObject] = []
    private var soundsNS :[NSManagedObject] = []
    let container = CKContainer.init(identifier: "iCloud.com.fku.WatchSoundboard1")
    var soundsArray : [SoundModel] = []

    
    override func awake(withContext context: Any?) {
        session = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: OperationQueue())
        super.awake(withContext: context)
        //UserDefaults.standard.set("8header8@googlemail.com", forKey: "adress")
        volumeView.focus()
        
        

        
        //getAllMp3FilesFromCloudContainer()

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
            var counter = 0
            for sound in soundsNS {
                counter = counter + 1
                let soundId = (sound.value(forKeyPath: "soundId") as! Int)
                let soundName = (sound.value(forKeyPath: "soundName") as! String)
                let soundImage = (sound.value(forKeyPath: "soundImage") as! String)
                let soundFile = (sound.value(forKeyPath: "soundFile") as! String)
                let soundVolume = (sound.value(forKeyPath: "soundVolume") as! Float)
                let showOnLS = (sound.value(forKeyPath: "showOnLS") as! Bool)

                let sound = SoundModel(soundId: soundId, soundName: soundName, soundImage: soundImage, soundFile: soundFile, soundVolume: soundVolume, showOnLS: showOnLS)
                soundsArray.append(sound)
                sound.print()
                if counter == soundsNS.count {
                    getAllMp3FilesFromCloudContainer()
                }
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
                
                //UserDefaults.standard.set("8header8@googlemail.com", forKey: "adress")
                let user = User(id: id, mail: mail, maxFilesCount: maxFilesCount, uploadedSoundsCount: uploadedSoundsCount, secret: secret, sounds: [], creationDate: creationDate)
                //user.print()
                print("mail: \(user.mail)")

            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        
        /*
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
                self.testLabel.setText("Please syncronise, mail empty")
            }
        }*/
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
    
    
    func getAllMp3FilesFromCloudContainer(){
        var counter = 0
        for sound in soundsArray {
            print("Count \(soundsArray.count)")
            counter = counter + 1
            let name = (sound.soundFile as NSString).deletingPathExtension

            getSoundWithId(name: name) { url in
                print("Name \(name) \nURL: \(url)")
                let localURL = soundsURL.appendingPathComponent("\(name).mp3")
                do {
                    if FileManager.default.fileExists(atPath: localURL.path) {
                        try FileManager.default.removeItem(at: localURL)
                    }
                    try FileManager.default.copyItem(at: url, to: localURL)
                    print("LocalUrl2: \(localURL)")
                } catch (let error) {
                    print("Cannot copy item at \(localURL) to \(url): \(error)")
                }
                if counter == self.soundsArray.count {
                    let encoder = PropertyListEncoder()
                    do{
                        let data = try encoder.encode(self.soundsArray)
                        try data.write(to: soundsURL.appendingPathComponent("sounds.plist"))
                        print("wrote sounds.plist \(self.soundsArray.count)")
                        DispatchQueue.main.async {
                            self.testLabel.setText("Downloaded")
                            let action = WKAlertAction(title: "Ok", style: WKAlertActionStyle.default) {
                                    print("Ok")
                                }
                            self.presentAlert(withTitle: "Downloaded", message: "Downloaded sounds1", preferredStyle: WKAlertControllerStyle.alert, actions:[action])
                        }
                    }catch{
                        print("Error encoding plist: \(error)")
                    }

                }
            } failure: { error in
                print("Error 45 \(error)")
            }
        }
        
        /*
        guard let cloudurl = FileManager.default.url(forUbiquityContainerIdentifier: "iCloud.com.fku.WatchSoundboard1")?.appendingPathComponent("Documents") else{
            print("no url")
            return
        }
        
        
        do {
            let directoryContents = try FileManager.default.contentsOfDirectory(at: cloudurl, includingPropertiesForKeys: nil)
            //print("directoryContents:", directoryContents.map { $0.localizedName ?? $0.lastPathComponent })
            for url1 in directoryContents {
                //let filename: NSString = url1.path as NSString
                //let pathExtention = filename.pathExtension
                //print(pathExtention)
                let bla = url1.localizedName ?? url1.lastPathComponent
                print("Name: \(bla)")
            }
            let mp3s = directoryContents.filter(\.isMP3).map { $0.localizedName ?? $0.lastPathComponent }
            print("mp3s:", mp3s)
    //        for mp3File in mp3s {
    //            let url = soundsURL.appendingPathComponent(mp3File)
    //            let sound = SoundModel(soundId: soundsNormal.count+1, soundName: mp3File, soundImage: "NoName", soundFile: mp3File, soundVolume: 1.0, soundFileURL: url)
    //            soundsNormal.append(sound)
    //        }
        } catch {
            print(error)
        }*/
    }
   
    func getSoundWithId(name: String, success: @escaping (_ url: URL) -> Void, failure: @escaping (_ error: String) -> Void){
        let id = CKRecord.ID(recordName: name)
        container.privateCloudDatabase.fetch(withRecordID: id) { record, error in
            if error != nil {
                failure("Err1 \(name) \(error!)")
            }else{
                if record != nil {
                    let file = record!.object(forKey: name)
                    print("file found \(name)")
                    if let asset = file as? CKAsset {
                        guard let url = asset.fileURL else {
                            failure("fileurl")
                            return
                        }
                        success(url)
                    }else{
                        failure("\(name) asset wrong")
                    }
                }else{
                    failure("\(name) record nil")
                }
            }
        }
    }
    
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


