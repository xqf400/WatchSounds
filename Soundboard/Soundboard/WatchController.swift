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

class WatchController: UIViewController {
    
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UserDefaults.standard.string(forKey: "adress") != nil{
            //DispatchQueue.main.async {
                let adress = UserDefaults.standard.string(forKey: "adress")
                self.mailTextfield.text = adress
            //self.transferMailToWatchButton.isEnabled = false
            //}
        }
        
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
        
    }
    
    
    
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
            UserDefaults.standard.set(adress, forKey: "adress")
            showHudSuccess(inView: self, text: "saved", delay: 1.0)
        }else{
            showHudError(inView: self, text: "Please fill in a mail", delay: 2.0)
        }
    }
    
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
            encryptData(ID: id, data: data) { encData in
                uploadToFireBase(fileName: self.mp3Name!, data: encData, folder: "Soundfiles") { str in
                    showHudSuccess(inView: self, text: "Uploaded", delay: 1.0)
                    self.mp3URL = nil
                    self.mp3Name = nil
                    self.selectedSoundLabel.text = "No sound selected"
                } failure: { error in
                    print("error 12 \(error)")
                    showHudError(inView: self, text: "Error 12: \(error)", delay: 2.0)
                }
            } failure: { error in
                print("Error encrypt user: \(error)")
                showHudError(inView: self, text: "Error 13: \(error)", delay: 2.0)
            }
        }else{
            showHudError(inView: self, text: "First select a sound file", delay: 2.0)
        }
    }
    

    private func uploadUserToUserInFirebase(id:Int, user: User, success: @escaping (_ str: String) -> Void, failure: @escaping (_ error: String) -> Void){



    }
    
    private func uploadPlistToFirebase(drink:User, success: @escaping (_ str: String) -> Void, failure: @escaping (_ error: String) -> Void){
        let encoder = PropertyListEncoder()
        do{
            let data = try encoder.encode(drink)
            encryptData(ID: "", data: data) { encData in
                let storageref = storage.reference().child("userLists/\(drink.mail).plist")
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
