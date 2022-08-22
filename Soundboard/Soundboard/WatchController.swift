//
//  FavViewController.swift
//  Soundboard
//
//  Created by Fabian Kuschke on 08.12.21.
//

import UIKit
import AVFoundation
import MediaPlayer
//import MessageUI
import ModelIO
import UniformTypeIdentifiers
//import WatchConnectivity
//import CoreData

class WatchController: UIViewController {
    
    
    @IBOutlet weak var secretLabel: UILabel!
    @IBOutlet weak var soundNameTextlabel: UITextField!
    @IBOutlet weak var uploadButtonOutlet: UIButton!
    @IBOutlet weak var selectedSoundLabel: UILabel!
    @IBOutlet weak var uploadSoundView: UIView!
    @IBOutlet weak var chooseSoundButtonOutlet: UIButton!
    @IBOutlet weak var transferMailToWatchButton: UIButton!
    @IBOutlet weak var mailTextfield: UITextField!
    @IBOutlet weak var actualMailLabel: UILabel!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var navBarTitle: UINavigationItem!
    @IBOutlet weak var volumeButtonOultet: UIBarButtonItem!
    //let backGroundColor = UIColor.yellow
    //let labelTextColor = UIColor.white
    //var grantedObserver :Void?
    
    var mp3URL : URL?
    var mp3Name: String?
    var session : URLSession!
    //var wcsession: WCSession?
    //private var infoUser :[NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        session = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: OperationQueue())
        
        if UserDefaults.standard.string(forKey: "adress") != nil{
            //DispatchQueue.main.async {
            let adress = UserDefaults.standard.string(forKey: "adress")
            self.mailTextfield.text = adress
            //self.transferMailToWatchButton.isEnabled = false
            //}
        }
        if UserDefaults.standard.string(forKey: "secret") != nil{
            let secret = UserDefaults.standard.string(forKey: "secret")!
            self.secretLabel.text = "Secret: \(secret)"
        }
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if loundSound {
            volumeButtonOultet.image = UIImage(systemName: "volume.3")
            if TargetDevice.currentDevice != .nativeMac {
                MPVolumeView.setVolume(1.0)
            }
        }else{
            volumeButtonOultet.image = UIImage(systemName: "volume")
        }
        
        let secret = randomString(length: 4)
        print(secret)
        
        //wcsession
        //        if WCSession.isSupported() {
        //            self.wcsession = WCSession.default
        //            self.wcsession!.delegate = self
        //            self.wcsession!.activate()
        //            print("startet")
        //            let alert = UIAlertController(title: "started", message: nil, preferredStyle: .alert)
        //            self.present(alert, animated: true, completion: nil)
        //            let when = DispatchTime.now() + 1
        //            DispatchQueue.main.asyncAfter(deadline: when){
        //              alert.dismiss(animated: true, completion: nil)
        //            }
        //        }
        
        //online Cloud data
        //        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
        //            return
        //        }
        //        let managedContext = appDelegate.persistentContainer.viewContext
        //        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Userinfo")
        //        do {
        //            infoUser = try managedContext.fetch(fetchRequest)
        //            for info in infoUser {
        //                let mail = (info.value(forKeyPath: "mail") as! String)
        //                print("mail: \(mail)")
        //            }
        //
        //        } catch let error as NSError {
        //            print("Could not fetch. \(error), \(error.userInfo)")
        //        }
        
    }
    
    
    //MARK: Actions
    @IBAction func stopAction(_ sender: Any) {
        if player != nil {
            player!.pause()
        }
        
    }
    
    
    @IBAction func volumeButtonAction(_ sender: Any) {
        
        loundSound = !loundSound
        UserDefaults.standard.set(loundSound, forKey: "loundSound")
        if loundSound {
            volumeButtonOultet.image = UIImage(systemName: "volume.3")
            if TargetDevice.currentDevice != .nativeMac {
                MPVolumeView.setVolume(1.0)
            }
        }else{
            volumeButtonOultet.image = UIImage(systemName: "volume")
        }
    }
    
    @IBAction func transferMailToWatchButtonAction(_ sender: Any) {
        if mailTextfield.text != ""{
            let adress = mailTextfield.text
            let secret = randomString(length: 4)
            let user = User(id: 0, mail: adress!, maxFilesCount: 2, uploadedSoundsCount: 0, secret: secret, sounds: [])
            UserDefaults.standard.set(adress, forKey: "adress")
            UserDefaults.standard.set(secret, forKey: "secret")
            uploadUserToUserInFirebase(user: user) { str in
                let userPlist = UserPlist(id: user.id, mail: user.mail, maxFilesCount: user.maxFilesCount, uploadedSoundsCount: user.uploadedSoundsCount, secret: user.secret, sounds: [])
                self.uploadPlistToFirebase(user: userPlist) { str in
                    DispatchQueue.main.async {
                        self.secretLabel.text = "Secret: \(secret)"
                    }
                    showHudSuccess(inView: self, text: "User and secret created. Please open th Watch App and enter the mail and secret.", delay: 2.0)
                    
                    /*
                     guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
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
                     } catch let error as NSError {
                     print("Could not save. \(error)")
                     }
                     
                     
                     
                     let alert = UIAlertController(title: "Please open Apple watch and go do the second page", message: "To tranfser your mail to your Watch the WatchSoundboard app must be open. Please open the WatchSoundboard app and go to the Download page and press the upload Button. If nothing happens please repeat it. \n\nIf you change your mail all sounds will be deleted!!!", preferredStyle: .alert)
                     alert.addAction(UIAlertAction(title: "Upload", style: .default, handler: { alert in
                     self.sendMailToWatch(mail: adress!) { str in
                     showHudSuccess(inView: self, text: "uploaded mail. You should see your mail on the Watch", delay: 1.0)
                     } failure: { error in
                     showHudError(inView: self, text: "Error watch app is not running", delay: 2.0)
                     }
                     }))
                     alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                     self.present(alert, animated: true)
                     */
                } failure: { error in
                    print("Failed to save1 upload \(error)")
                    showHudError(inView: self, text: "Failed to save1 upload \(error)", delay: 2.0)
                }
            } failure: { error in
                print("Failed to save2 upload \(error)")
                showHudError(inView: self, text: "Failed to save2 upload \(error)", delay: 2.0)
            }
            
            
            
        }else{
            showHudError(inView: self, text: "Please fill in a mail", delay: 2.0)
        }
    }
    
    /*
     private func sendMailToWatch(mail:String, success: @escaping (_ str: String) -> Void, failure: @escaping (_ error: String) -> Void){
     if let validSession = self.wcsession, validSession.isReachable {
     let data: [String: Any] = ["mail": mail as Any]
     validSession.sendMessage(data, replyHandler: nil, errorHandler: nil)
     validSession.sendMessage(["msg" : "\(mail)" as AnyObject]) { test in
     print(test)
     showHudSuccess(inView: self, text: "sended", delay: 1.0)
     }
     }else{
     showHudError(inView: self, text: "No Session available", delay: 2.0)
     }
     }*/
    
    @IBAction func chooseSoundButtonAction(_ sender: Any) {
        var documentPicker: UIDocumentPickerViewController!
        let supportedTypes: [UTType] = [UTType.mp3]
        documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: supportedTypes)
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = false
        documentPicker.modalPresentationStyle = .formSheet
        self.present(documentPicker, animated: true, completion: nil)
    }
    
    @IBAction func uploadSoundButtonAction(_ sender: Any) {
        if UserDefaults.standard.string(forKey: "adress") != nil{
            if soundNameTextlabel.text != "" {
                if mp3URL != nil && mp3Name != nil{
                    guard let data = try? Data(contentsOf: mp3URL!) else {
                        print("data nil")
                        showHudError(inView: self, text: "data nil", delay: 2.0)
                        return
                    }
                    
                    var id = ""
                    if UserDefaults.standard.string(forKey: "adress") != nil{
                        id = UserDefaults.standard.string(forKey: "adress")!
                    }
                    
                    self.getUserAccountIfExist(mail: id) { account in
                        if account.uploadedSoundsCount < account.maxFilesCount {
                            let newAccount = account
                            encryptData(ID: id, data: data) { encData in
                                uploadToFireBase(fileName: self.mp3Name!, data: encData, folder: "Soundfiles") { str in
                                    newAccount.sounds.append(self.mp3Name!)
                                    newAccount.uploadedSoundsCount = newAccount.uploadedSoundsCount + 1
                                    
                                    
                                    downloadDataFromFireBase(name: "\(id).plist", folder: "userLists", session: self.session) { data in
                                        decodeClipFromData(data: data) { user in
                                            let newAccount2 = UserPlist(id: newAccount.id, mail: newAccount.mail, maxFilesCount: newAccount.maxFilesCount, uploadedSoundsCount: newAccount.uploadedSoundsCount, secret: newAccount.secret, sounds: user.sounds)
                                            
                                            let newSound = SoundModel(soundId: 0, soundName: self.soundNameTextlabel.text!, soundImage: "NoName", soundFile: self.mp3Name!, soundVolume: 1.0, soundFileURL: URL(string: "https://google.de")!)
                                            newAccount2.sounds.append(newSound)
                                            
                                            self.uploadPlistToFirebase(user: newAccount2) { str in
                                                self.uploadUserToUserInFirebase(user: newAccount) { str in
                                                    showHudSuccess(inView: self, text: "Uploaded", delay: 1.0)
                                                    self.mp3URL = nil
                                                    self.mp3Name = nil
                                                    self.soundNameTextlabel.text = ""
                                                    self.selectedSoundLabel.text = "No sound selected"
                                                } failure: { error in
                                                    print("Failed to save1 upload \(error)")
                                                    showHudError(inView: self, text: "Failed to save1 upload \(error)", delay: 2.0)
                                                }
                                            } failure: { error in
                                                print("Failed to save2 upload \(error)")
                                                showHudError(inView: self, text: "Failed to save2 upload \(error)", delay: 2.0)
                                            }
                                            
                                            
                                        } failure: { error in
                                            print("Failed to decode plist upload \(error)")
                                            showHudError(inView: self, text: "Failed to save2 upload \(error)", delay: 2.0)
                                        }
                                        
                                    } failure: { [self] error in
                                        print("no error just no file do same")
                                        
                                        let newAccount2 = UserPlist(id: newAccount.id, mail: newAccount.mail, maxFilesCount: newAccount.maxFilesCount, uploadedSoundsCount: newAccount.uploadedSoundsCount, secret: newAccount.secret, sounds: [])
                                        let newSound = SoundModel(soundId: 0, soundName: self.soundNameTextlabel.text!, soundImage: "NoName", soundFile: self.mp3Name!, soundVolume: 1.0, soundFileURL: URL(string: "https://google.de")!)
                                        newAccount2.sounds.append(newSound)
                                        self.uploadPlistToFirebase(user: newAccount2) { str in
                                            self.uploadUserToUserInFirebase(user: newAccount) { str in
                                                showHudSuccess(inView: self, text: "Uploaded", delay: 1.0)
                                                self.mp3URL = nil
                                                self.mp3Name = nil
                                                self.soundNameTextlabel.text = ""
                                                self.selectedSoundLabel.text = "No sound selected"
                                            } failure: { error in
                                                print("Failed to save1 upload \(error)")
                                                showHudError(inView: self, text: "Failed to save1 upload \(error)", delay: 2.0)
                                            }
                                        } failure: { error in
                                            print("Failed to save2 upload \(error)")
                                            showHudError(inView: self, text: "Failed to save2 upload \(error)", delay: 2.0)
                                        }
                                    }
                                } failure: { error in
                                    print("error 12 \(error)")
                                    showHudError(inView: self, text: "Error 12: \(error)", delay: 2.0)
                                }
                            } failure: { error in
                                print("Error encrypt user: \(error)")
                                showHudError(inView: self, text: "Error 13: \(error)", delay: 2.0)
                            }
                        }else{
                            showHudError(inView: self, text: "max files buy more", delay: 2.0)
                        }
                    } failure: { error in
                        print("Failed get User Account If Exist \(error)")
                        showHudError(inView: self, text: "Failed get User Account \(error)", delay: 2.0)
                    }
                    
                }else{
                    showHudError(inView: self, text: "First select a sound file", delay: 2.0)
                }
            }else{
                showHudError(inView: self, text: "Please set up first a sound name", delay: 2.0)
            }
        }else{
            showHudError(inView: self, text: "Please set up first a mail adress", delay: 2.0)
        }
    }
    
    //MARK: Functions
    private func uploadUserToUserInFirebase(user: User, success: @escaping (_ secret: String) -> Void, failure: @escaping (_ error: String) -> Void){
        getUserAccountIfExist(mail: user.mail) { account in
            db.collection("accounts").document(user.mail).setData(user.dictionary) { error in
                if let err = error{
                    failure("err user \(err)")
                }else{
                    let secret = account.secret
                    print("suc1 \(user.uploadedSoundsCount)")
                    success(secret)
                }
            }
        } failure: { error in
            db.collection("accounts").document(user.mail).setData(user.dictionary) { error in
                if let err = error{
                    failure("err user \(err)")
                }else{
                    print("suc1 \(user.uploadedSoundsCount)")
                    success(user.secret)
                }
            }
            
        }
        
    }
    
    
    func getUserAccountIfExist(mail: String,success: @escaping (_ account: User) -> Void, failure: @escaping (_ error: String) -> Void){
        let docRef = db.collection("accounts").document(mail)
        docRef.getDocument { (document, error) in
            if document != nil {
                if document!.exists {
                    guard let UserAccount = User(dictionary: document!.data()!) else {return}
                    success(UserAccount)
                } else {
                    failure("1Document does not exist1")
                }
            }else {
                failure("2Document does not exist")
            }
        }
    }
    
    
    private func uploadPlistToFirebase(user:UserPlist, success: @escaping (_ str: String) -> Void, failure: @escaping (_ error: String) -> Void){
        let encoder = PropertyListEncoder()
        do{
            let data = try encoder.encode(user)
            encryptData(ID: "", data: data) { encData in
                let storageref = storage.reference().child("userLists/\(user.mail).plist")
                _ = storageref.putData(encData, metadata: nil) { (metadata, error) in
                    if error != nil {
                        failure(error!.localizedDescription)
                    }else{
                        success("uploaded Plist")
                    }
                }
            } failure: { error in
                print("Error encrypt drink: \(error)")
                failure(error)
            }
        }catch{
            print("Error encoding drink: \(error)")
            failure(error.localizedDescription)
        }
    }
    
    
    func randomString(length: Int) -> String {
        let letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        //let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }
    
}//eoc


extension WatchController: AVAudioPlayerDelegate {
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            
        }
    }
}
//MARK: UIDocumentPickerDelegate
extension WatchController: UIDocumentPickerDelegate {
    
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        if controller.allowsMultipleSelection {
            print("WARNING: controller allows multiple file selection, but coordinate-read code here assumes only one file chosen")
            // If this is intentional, you need to modify the code below to do coordinator.coordinate
            // on MULTIPLE items, not just the first one
            if urls.count > 0 { print("Ignoring all but the first chosen file") }
        }
        
        let firstFileURL = urls[0]
        let isSecuredURL = (firstFileURL.startAccessingSecurityScopedResource() == true)
        
        //print("UIDocumentPickerViewController gave url = \(firstFileURL)")
        
        // Status monitoring for the coordinate block's outcome
        var blockSuccess = false
        var outputFileURL: URL? = nil
        
        // Execute (synchronously, inline) a block of code that will copy the chosen file
        // using iOS-coordinated read to cooperate on access to a file we do not own:
        let coordinator = NSFileCoordinator()
        var error: NSError? = nil
        coordinator.coordinate(readingItemAt: firstFileURL, options: [], error: &error) { (externalFileURL) -> Void in
            
            // WARNING: use 'externalFileURL in this block, NOT 'firstFileURL' even though they are usually the same.
            // They can be different depending on coordinator .options [] specified!
            
            // Create file URL to temp copy of file we will create:
            var tempURL = URL(fileURLWithPath: NSTemporaryDirectory())
            tempURL.appendPathComponent(externalFileURL.lastPathComponent)
            //print("Will attempt to copy file to tempURL = \(tempURL)")
            
            // Attempt copy
            do {
                // If file with same name exists remove it (replace file with new one)
                if FileManager.default.fileExists(atPath: tempURL.path) {
                    //print("Deleting existing file at: \(tempURL.path) ")
                    try FileManager.default.removeItem(atPath: tempURL.path)
                }
                
                // Move file from app_id-Inbox to tmp/filename
                //print("Attempting move file to: \(tempURL.path) ")
                try FileManager.default.moveItem(atPath: externalFileURL.path, toPath: tempURL.path)
                
                blockSuccess = true
                outputFileURL = tempURL
            }
            catch {
                print("File operation error: " + error.localizedDescription)
                blockSuccess = false
            }
            
        }
        navigationController?.dismiss(animated: true, completion: nil)
        
        if error != nil {
            print("NSFileCoordinator() generated error while preparing, and block was never executed")
            return
        }
        if !blockSuccess {
            print("Block executed but an error was encountered while performing file operations")
            return
        }
        
        //print("Output URL : \(String(describing: outputFileURL))")
        
        if (isSecuredURL) {
            firstFileURL.stopAccessingSecurityScopedResource()
        }
        
        if let out = outputFileURL {
            //print("fileURL: \(out)")
            mp3URL = out
            let name = out.lastPathComponent
            mp3Name = name
            DispatchQueue.main.async {
                self.selectedSoundLabel.text = name
            }
        }
    }
    
    
}

extension WatchController: URLSessionDelegate {
    
    
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

//MARK: WCSession delegate functions
/*
 extension WatchController: WCSessionDelegate {
 
 func sessionDidBecomeInactive(_ session: WCSession) {
 }
 
 func sessionDidDeactivate(_ session: WCSession) {
 }
 
 func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
 }
 
 func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
 print("received message: \(message)")
 DispatchQueue.main.async { //6
 if let value = message["watch"] as? String {
 print("watch got \(value)")
 self.transferMailToWatchButton.setTitle("sended to watch", for: .normal)
 self.transferMailToWatchButton.titleLabel?.text = "sended to watch"
 }
 }
 }
 }*/
