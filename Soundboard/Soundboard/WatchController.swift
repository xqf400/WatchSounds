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
import CoreData
import JGProgressHUD
import CloudKit

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
    private var infoUser :[NSManagedObject] = []
    private var soundsNS :[NSManagedObject] = []
    let loadingHud = JGProgressHUD()
    let container = CKContainer.init(identifier: "iCloud.com.fku.WatchSoundboard1")
    var soundsArray : [SoundModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        session = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: OperationQueue())
        
        
        if UserDefaults.standard.string(forKey: "secret") != nil && UserDefaults.standard.string(forKey: "adress") != nil{
            let adress = UserDefaults.standard.string(forKey: "adress")!
            self.mailTextfield.text = adress
            
            let secret = UserDefaults.standard.string(forKey: "secret")!
            self.secretLabel.text = "Upper and lower case is unimportant on the watch app. \nMail: \(adress)\nSecret: \(secret)"
        }
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        //online Cloud data
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        /*
         let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "UserI")
         do {
         infoUser = try managedContext.fetch(fetchRequest)
         for info in infoUser {
         let mail = (info.value(forKeyPath: "mail") as! String)
         let id = (info.value(forKeyPath: "id") as! Int)
         let maxFilesCount = (info.value(forKeyPath: "maxFilesCount") as! Int)
         let uploadedSoundsCount = (info.value(forKeyPath: "uploadedSoundsCount") as! Int)
         let secret = (info.value(forKeyPath: "secret") as! String)
         let creationDate = (info.value(forKeyPath: "creationDate") as! String)
         
         let user = User(id: id, mail: mail, maxFilesCount: maxFilesCount, uploadedSoundsCount: uploadedSoundsCount, secret: secret, sounds: [], creationDate: creationDate)
         //user.print()
         }
         } catch let error as NSError {
         print("Could not fetch. \(error), \(error.userInfo)")
         }*/
        
        //        let fetchRequest2: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Sounds")
        //        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest2)
        //
        //        do {
        //            try managedContext.execute(deleteRequest)
        //        } catch let error as NSError {
        //            // TODO: handle the error
        //        }
        
        let fetchRequest1 = NSFetchRequest<NSManagedObject>(entityName: "Sounds")
        //print("Fetch \(fetchRequest)")
        
        //Delete all
        /*
        let fetchRequestDelete: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Sounds")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequestDelete)
        do {
            try managedContext.execute(deleteRequest)
            print("deleted all")
        } catch let error as NSError {
            print("Error deleting all \(error)")
        }*/
        
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

        
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if loundSound {
            volumeButtonOultet.image = UIImage(systemName: "speaker.wave.3.fill")
            if TargetDevice.currentDevice != .nativeMac {
                MPVolumeView.setVolume(1.0)
            }
        }else{
            volumeButtonOultet.image = UIImage(systemName: "speaker.wave.1")
        }
        
        
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
            volumeButtonOultet.image = UIImage(systemName: "speaker.wave.3.fill")
            if TargetDevice.currentDevice != .nativeMac {
                MPVolumeView.setVolume(1.0)
            }
        }else{
            volumeButtonOultet.image = UIImage(systemName: "speaker.wave.1")
        }
    }
    
    //MARK: Transfer Mail
    @IBAction func transferMailToWatchButtonAction(_ sender: Any) {
        
        if mailTextfield.text != ""{
            self.loadingHud.textLabel.text = "Bitte warten..."
            self.loadingHud.show(in: self.view, animated: true)
            let adress = mailTextfield.text!.lowercased()
            let secret = randomString(length: 4)
            let user = User(id: 0, mail: adress, maxFilesCount: 2, uploadedSoundsCount: 0, secret: secret, sounds: [], creationDate: getActualTimeAndDate())
            
            //if useCoreData {
                guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                    print("Error 2343")
                    return
                }
                let managedContext = appDelegate.persistentContainer.viewContext
                let entity = NSEntityDescription.entity(forEntityName: "UserI", in: managedContext)!
                let soundObject = NSManagedObject(entity: entity, insertInto: managedContext)
                soundObject.setValue(user.mail, forKeyPath: "mail")
                soundObject.setValue(user.creationDate, forKeyPath: "creationDate")
                soundObject.setValue(user.id, forKeyPath: "id")
                soundObject.setValue(user.maxFilesCount, forKeyPath: "maxFilesCount")
                soundObject.setValue(user.secret, forKeyPath: "secret")
                soundObject.setValue(user.uploadedSoundsCount, forKeyPath: "uploadedSoundsCount")
                do {
                    try managedContext.save()
                    infoUser.append(soundObject)
                    print("suc database")
                    DispatchQueue.main.async {
                        self.secretLabel.text = "Upper and lower case is unimportant on the watch app. \nMail: \(adress)\nSecret: \(secret)"
                    }
                    UserDefaults.standard.set(adress, forKey: "adress")
                    UserDefaults.standard.set(secret, forKey: "secret")
                    self.loadingHud.dismiss(animated: false)
                    showHudSuccess(inView: self, text: "User and secret created. Please open the Watch App and enter the mail and secret.", delay: 2.0)
                } catch let error as NSError {
                    print("Could not save. \(error)")
                }
            //}else{//cordata
                uploadUserToUserInFirebase(user: user) { str in
                    //let userPlist = UserPlist(id: user.id, mail: user.mail, maxFilesCount: user.maxFilesCount, uploadedSoundsCount: user.uploadedSoundsCount, secret: user.secret, sounds: [], creationDate: user.creationDate)
                    let userPlist = UserPlist(user: user, sounds: [])
                    self.uploadPlistToFirebase(user: userPlist) { str in
                        DispatchQueue.main.async {
                            self.secretLabel.text = "Upper and lower case is unimportant on the watch app. \nMail: \(adress)\nSecret: \(secret)"
                        }
                        UserDefaults.standard.set(adress, forKey: "adress")
                        UserDefaults.standard.set(secret, forKey: "secret")
                        self.loadingHud.dismiss(animated: false)
                        showHudSuccess(inView: self, text: "User and secret created. Please open the Watch App and enter the mail and secret.", delay: 2.0)
                        
                        /*
                         
                         
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
                        self.loadingHud.dismiss(animated: false)
                        showHudError(inView: self, text: "Failed to save1 upload \(error)", delay: 2.0)
                    }
                } failure: { error in
                    print("Failed to save2 upload \(error)")
                    self.loadingHud.dismiss(animated: false)
                    showHudError(inView: self, text: "Failed to save2 upload \(error)", delay: 2.0)
                }
            //}//coredata
        }else{
            showHudError(inView: self, text: "Please fill in a mail", delay: 2.0)
            
//            getSoundWithName(name: "LaylaKurz") { url in
//                print("Url \(url)")
//            } failure: { error in
//                print("Error soundname: \(error)")
//            }
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
    
    //MARK: Choose Sound
    @IBAction func chooseSoundButtonAction(_ sender: Any) {
        
        var documentPicker: UIDocumentPickerViewController!
        let supportedTypes: [UTType] = [UTType.mp3]
        documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: supportedTypes)
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = false
        documentPicker.modalPresentationStyle = .formSheet
        self.present(documentPicker, animated: true, completion: nil)
    }
    
    //MARK: Upload  sound
    @IBAction func uploadSoundButtonAction(_ sender: Any) {
        if UserDefaults.standard.string(forKey: "adress") != nil{
            if soundNameTextlabel.text != "" {
                if mp3URL != nil && mp3Name != nil{
                    guard let data = try? Data(contentsOf: mp3URL!) else {
                        print("data nil")
                        showHudError(inView: self, text: "data nil", delay: 2.0)
                        return
                    }
                    self.loadingHud.textLabel.text = "Bitte warten..."
                    self.loadingHud.show(in: self.view, animated: true)
                    var id = ""
                    if UserDefaults.standard.string(forKey: "adress") != nil{
                        id = UserDefaults.standard.string(forKey: "adress")!
                    }
                    let newSound = SoundModel(soundId: soundsNS.count+1, soundName: self.soundNameTextlabel.text!, soundImage: "NoName", soundFile: self.mp3Name!, soundVolume: 1.0, showOnLS: false)
                    
                    //if useCoreData {
                        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                            print("Error 2343")
                            return
                        }
                        let managedContext = appDelegate.persistentContainer.viewContext
                        let entity = NSEntityDescription.entity(forEntityName: "Sounds", in: managedContext)!
                        let soundObject = NSManagedObject(entity: entity, insertInto: managedContext)
                        soundObject.setValue(newSound.soundId, forKeyPath: "soundId")
                        soundObject.setValue(newSound.soundName, forKeyPath: "soundName")
                        soundObject.setValue(newSound.soundImage, forKeyPath: "soundImage")
                        soundObject.setValue(newSound.soundFile, forKeyPath: "soundFile")
                        soundObject.setValue(newSound.soundVolume, forKeyPath: "soundVolume")
                        soundObject.setValue(newSound.showOnLS, forKeyPath: "showOnLS")

                        do {
                            try managedContext.save()
                            soundsNS.append(soundObject)
                            print("todo save db")
                            print("suc database \(newSound.soundName)")
                            
                            saveSongToCloudContainer(fileName: newSound.soundFile, url: mp3URL!) { str in
                                print(str)
                                saveSongLocal(song: newSound, data: data) { str in
                                    DispatchQueue.main.async {
                                    self.loadingHud.dismiss(animated: false)
                                    showHudSuccess(inView: self, text: "Uploaded", delay: 1.0)
                                        if useCoreData{
                                            self.mp3URL = nil
                                            self.mp3Name = nil
                                        }
                                    self.soundNameTextlabel.text = ""
                                    self.selectedSoundLabel.text = "No sound selected"
                                    }
                                    self.soundsArray.append(newSound)
                                    self.getAllMp3FilesFromCloudContainer()

                                } failure: { error in
                                    print("Failed to save1 upload \(error)")
                                    DispatchQueue.main.async {
                                    self.loadingHud.dismiss(animated: false)
                                    showHudError(inView: self, text: "Failed to save1 local \(error)", delay: 2.0)
                                    }
                                }
                            } failure: { error in
                                print("Failed to save1 upload \(error)")
                                DispatchQueue.main.async {
                                self.loadingHud.dismiss(animated: false)
                                showHudError(inView: self, text: "Failed to save1 cloud \(error)", delay: 2.0)
                                }
                            }
                        } catch let error as NSError {
                            print("Could not save. \(error)")
                        }
                    //}else{//coredata
                        
                        self.getUserAccountIfExist(mail: id) { account in
                            //print("got user")
                            if account.uploadedSoundsCount < account.maxFilesCount {
                                let newAccount = account
                                encryptData(ID: id, data: data) { encData in
                                    uploadToFireBase(fileName: self.mp3Name!, data: encData, folder: "Soundfiles") { str in
                                        //print("uploaded Sound")
                                        newAccount.sounds.append(self.mp3Name!)
                                        newAccount.uploadedSoundsCount = newAccount.uploadedSoundsCount + 1
                                        
                                        downloadDataFromFireBase(name: "\(id).plist", folder: "userLists", session: self.session) { data1 in
                                            //print("downloaded plist")
                                            decodeClipFromData(data: data1) { user in
                                                //MARK: exist
                                                //let newAccount2 = UserPlist(id: newAccount.id, mail: newAccount.mail, maxFilesCount: newAccount.maxFilesCount, uploadedSoundsCount: newAccount.uploadedSoundsCount, secret: newAccount.secret, sounds: user.sounds, creationDate: user.creationDate)
                                                let newAccount2 = UserPlist(user: newAccount, sounds: user.sounds)
                                                
                                                newAccount2.sounds.append(newSound)
                                                
                                                self.uploadPlistToFirebase(user: newAccount2) { str in
                                                    //print("uploaded plist")
                                                    self.uploadUserToUserInFirebase(user: newAccount) { str in
                                                        //print("uploaded User")
                                                        saveSongLocal(song: newSound, data: data) { str in
                                                            self.loadingHud.dismiss(animated: false)
                                                            showHudSuccess(inView: self, text: "Uploaded", delay: 1.0)
                                                            self.mp3URL = nil
                                                            self.mp3Name = nil
                                                            self.soundNameTextlabel.text = ""
                                                            self.selectedSoundLabel.text = "No sound selected"
                                                        } failure: { error in
                                                            print("Failed to save1 upload \(error)")
                                                            self.loadingHud.dismiss(animated: false)
                                                            showHudError(inView: self, text: "Failed to save1 local \(error)", delay: 2.0)
                                                        }
                                                    } failure: { error in
                                                        self.loadingHud.dismiss(animated: false)
                                                        print("Failed to save1 upload \(error)")
                                                        showHudError(inView: self, text: "Failed to save1 upload \(error)", delay: 2.0)
                                                    }
                                                } failure: { error in
                                                    self.loadingHud.dismiss(animated: false)
                                                    print("Failed to save2 upload \(error)")
                                                    showHudError(inView: self, text: "Failed to save2 upload \(error)", delay: 2.0)
                                                }
                                            } failure: { error in
                                                self.loadingHud.dismiss(animated: false)
                                                print("Failed to decode plist upload \(error)")
                                                showHudError(inView: self, text: "Failed to save2 upload \(error)", delay: 2.0)
                                            }
                                        } failure: { [self] error in
                                            print("no error just no file do same")
                                            //MARK: doesnt exist
                                            //let newAccount2 = UserPlist(id: newAccount.id, mail: newAccount.mail, maxFilesCount: newAccount.maxFilesCount, uploadedSoundsCount: newAccount.uploadedSoundsCount, secret: newAccount.secret, sounds: [], creationDate: newAccount.creationDate)
                                            let newAccount2 = UserPlist(user: newAccount, sounds: [])
                                            newAccount2.sounds.append(newSound)
                                            self.uploadPlistToFirebase(user: newAccount2) { str in
                                                self.uploadUserToUserInFirebase(user: newAccount) { str in
                                                    
                                                    saveSongLocal(song: newSound, data: data) { str in
                                                        self.loadingHud.dismiss(animated: false)
                                                        showHudSuccess(inView: self, text: "Uploaded", delay: 1.0)
                                                        self.mp3URL = nil
                                                        self.mp3Name = nil
                                                        self.soundNameTextlabel.text = ""
                                                        self.selectedSoundLabel.text = "No sound selected"
                                                    } failure: { error in
                                                        print("Failed to save1 upload \(error)")
                                                        self.loadingHud.dismiss(animated: false)
                                                        showHudError(inView: self, text: "Failed to save1 local \(error)", delay: 2.0)
                                                    }
                                                } failure: { error in
                                                    print("Failed to save1 upload \(error)")
                                                    self.loadingHud.dismiss(animated: false)
                                                    showHudError(inView: self, text: "Failed to save1 upload \(error)", delay: 2.0)
                                                }
                                            } failure: { error in
                                                print("Failed to save2 upload \(error)")
                                                self.loadingHud.dismiss(animated: false)
                                                showHudError(inView: self, text: "Failed to save2 upload \(error)", delay: 2.0)
                                            }
                                        }
                                    } failure: { error in
                                        print("error 12 \(error)")
                                        self.loadingHud.dismiss(animated: false)
                                        showHudError(inView: self, text: "Error 12: \(error)", delay: 2.0)
                                    }
                                } failure: { error in
                                    print("Error encrypt user: \(error)")
                                    self.loadingHud.dismiss(animated: false)
                                    showHudError(inView: self, text: "Error 13: \(error)", delay: 2.0)
                                }
                            }else{
                                self.loadingHud.dismiss(animated: false)
                                showHudError(inView: self, text: "max files buy more", delay: 2.0)
                            }
                        } failure: { error in
                            print("Failed get User Account If Exist \(error)")
                            self.loadingHud.dismiss(animated: false)
                            showHudError(inView: self, text: "Failed get User Account \(error)", delay: 2.0)
                        }
                    //}//coredata
                }else{
                    showHudError(inView: self, text: "First select a sound file", delay: 2.0)
                }
            }else{
                showHudError(inView: self, text: "Please set up first a sound name", delay: 2.0)
            }
        }else{
            if mp3URL != nil && mp3Name != nil{
                
//                saveSongToCloudContainer(fileName: mp3Name!, url: mp3URL!) { str in
//                    print(str)
//                } failure: { error in
//                    print("Er23 \(error)")
//                }


                
                
                let alert = UIAlertController(title: "No Mail configured", message: "Do you just want to save it local?", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Just save normal", style: .default, handler: { action in
                    guard let data = try? Data(contentsOf: self.mp3URL!) else {
                        print("data nil")
                        showHudError(inView: self, text: "data nil", delay: 2.0)
                        return
                    }
                    self.loadingHud.textLabel.text = "Bitte warten..."
                    self.loadingHud.show(in: self.view, animated: true)
                    let newSound = SoundModel(soundId: 0, soundName: self.soundNameTextlabel.text!, soundImage: "NoName", soundFile: self.mp3Name!, soundVolume: 1.0, showOnLS: false)
                    
                    saveSongLocal(song: newSound, data: data) { str in
                        self.loadingHud.dismiss(animated: false)
                        showHudSuccess(inView: self, text: "Uploaded", delay: 1.0)
                        self.mp3URL = nil
                        self.mp3Name = nil
                        self.soundNameTextlabel.text = ""
                        self.selectedSoundLabel.text = "No sound selected"
                    } failure: { error in
                        print("Failed to save1 upload \(error)")
                        self.loadingHud.dismiss(animated: false)
                        showHudError(inView: self, text: "Failed to save1 local \(error)", delay: 2.0)
                    }
                }))
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                self.present(alert, animated: true)
            }else{
                self.loadingHud.dismiss(animated: false)
                showHudError(inView: self, text: "Please selecet a sound and set a name", delay: 2.0)
            }
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
                    print("got User \(user.uploadedSoundsCount)")
                    success(secret)
                }
            }
        } failure: { error in
            db.collection("accounts").document(user.mail).setData(user.dictionary) { error in
                if let err = error{
                    failure("err user \(err)")
                }else{
                    print("got User1 \(user.uploadedSoundsCount)")
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
                    guard let UserAccount = User(dictionary: document!.data()!) else {
                        failure("3Document does not exist")
                        return
                    }
                    success(UserAccount)
                } else {
                    failure("1Document does not exist")
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
                let storageref = storage.reference().child("userLists/\(user.user.mail).plist")
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
    
    //MARK: Save song to Cloud
     
    func saveSongToCloudContainer(fileName: String,url: URL,success: @escaping (_ str: String) -> Void, failure: @escaping (_ error: String) -> Void){
        //let fileName = "Iloveit.mp3"
        print("FileName: \(fileName)")
        let name = (fileName as NSString).deletingPathExtension
        let id = CKRecord.ID(recordName: name)
        let newRecord1 = CKRecord(recordType: name, recordID: id)
        
        let File1 = CKAsset(fileURL: url)
        newRecord1.setObject(File1, forKey: name)
        container.privateCloudDatabase.save(newRecord1) { record, error in
            if error != nil {
                print("Err6 \(error!)")
                failure("Err6 \(error!)")
            }
            print("Rec3 uploaded \(id.recordName)")
            success("Rec2 uploaded \(id.recordName)")
        }
        
        
        /*
        guard let data = try? Data(contentsOf: mp3URL!) else {
            print("data nil")
            showHudError(inView: self, text: "data nil", delay: 2.0)
            failure("data nil")
            return
        }
        let manager = FileManager.default
        guard let cloudurl = manager.url(forUbiquityContainerIdentifier: "iCloud.com.fku.WatchSoundboard1")?.appendingPathComponent("Documents") else{
            print("no url")
            showHudError(inView: self, text: "url error", delay: 2.0)
            failure("no url")
            return
        }
        let url = cloudurl.appendingPathComponent(songFile)

        do{
            //try data.write(to: url)
            try manager.setUbiquitous(true, itemAt: mp3URL!, destinationURL: url)

            print("1wrote \(songFile) \(url)")
            success("1wrote \(songFile) \(url)")
        }catch{
            print("Error 35 \(error.localizedDescription)")
            failure("Error 35 \(error.localizedDescription)")
        }*/
    }
    
    func getAllMp3FilesFromCloudContainer(){
        //let fileName = "Iloveit.mp3"
        
        container.accountStatus { status, error in
            if error != nil {
                print("error \(error!)")
            }else{
                print("status \(status.rawValue)")
            }
        }
        
        for sound in soundsArray {
            let name = (sound.soundFile as NSString).deletingPathExtension
            print("Name: \(name)")
            getSoundWithName(name: name) { url in
                print("Name \(name) \nURL: \(url)")
            } failure: { error in
                print("Error 45 \(error)")
                DispatchQueue.main.async {
                showHudError(inView: self, text: error, delay: 2.0)
                }
            }
        }
        /*
        do {
            let directoryContents = try FileManager.default.contentsOfDirectory(at: cloudurl, includingPropertiesForKeys: nil)
            //print("directoryContents:", directoryContents.map { $0.localizedName ?? $0.lastPathComponent })
//            for url1 in directoryContents {
//                //let filename: NSString = url1.path as NSString
//                //let pathExtention = filename.pathExtension
//                //print(pathExtention)
//                let bla = url1.localizedName ?? url1.lastPathComponent
//                print("Name: \(bla)")
//
//            }
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
    
    func getSoundWithName(name: String, success: @escaping (_ url: URL) -> Void, failure: @escaping (_ error: String) -> Void){
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
                            failure(" \(name) fileurl")
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
