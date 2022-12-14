//
//  ViewController.swift
//  WatchSounds
//
//  Created by Fabian Kuschke on 10.08.22.
//

import UIKit
import ModelIO
import UniformTypeIdentifiers
import WatchConnectivity

class ViewController: UIViewController, WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("Session: ", session.applicationContext)
        if error != nil {
            print(error!)
        }
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        print("active")
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        print("deactive")

    }
    
    
    
    @IBOutlet weak var testImageView: UIImageView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var countLabel: UILabel!
    //let url =FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.fku.watchSounds.SharingData")
    var mp3URL : URL?
    var names : [String] = []
    let cloudManager = CloudDataManager()
    var image: UIImage!
    //var userDefaults = UserDefaults.init(suiteName: "group.fku.watchSounds.SharingData")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //getLocalFiles()
        //getAllOnlineFiles()
//        userDefaults!.set("Testphone", forKey: "testphone")
//        userDefaults!.synchronize()
//        countLabel.text = "Test: \(userDefaults!.string(forKey: "testwatch"))"
        image = UIImage(named: "commit.jpeg")
        testImageView.image = image
        if WCSession.isSupported() {
            WCSession.default.delegate = self
            WCSession.default.activate()
        }
        
    }
    
    private func getLocalFiles(){
        let tempURL = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).first!
        
        //print(tempURL)
        do {
            let directoryContents = try FileManager.default.contentsOfDirectory(at: tempURL, includingPropertiesForKeys: nil)
            //print("directoryContents:", directoryContents.map { $0.localizedName ?? $0.lastPathComponent })
            //            for url1 in directoryContents {
            //
            //                print(url1.localizedName ?? url1.lastPathComponent)
            //            }
            
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
            //            for mp3File in mp3s {
            //                names.append(mp3File)
            //            }
            //countLabel.text = "Count: \(names.count)"
            
        } catch {
            print(error)
        }
    }
    
    private func getAllOnlineFiles(){
        if cloudManager.isCloudEnabled() {
            let url = CloudDataManager.sharedInstance.getDocumentDiretoryURL()
            //print("icloud works")
            //cloudManager.enableCloudExample()
            let tempURL = url
            //print(tempURL)
            do {
                let directoryContents = try FileManager.default.contentsOfDirectory(at: tempURL, includingPropertiesForKeys: nil)
                //print("directoryContents:", directoryContents.map { $0.localizedName ?? $0.lastPathComponent })
                for url1 in directoryContents {
                    textView.text.append("Name:\(url1.localizedName!)\n")
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
                    names.append(mp3File)
                }
                countLabel.text = "Online Count: \(names.count)"
                
            } catch {
                print(error)
            }
        }else{
            print("enable cloud")
        }
    }
    
    @IBAction func uploadFile(_ sender: Any) {
        let data = image.jpegData(compressionQuality: 1.0)

        WCSession.default.sendMessageData(data!, replyHandler: { (data) -> Void in
            // handle the response from the device
            print("sent")
            let alert = UIAlertController(title: "sent", message: nil, preferredStyle: .alert)
            self.present(alert, animated: true, completion: nil)
            let when = DispatchTime.now() + 2
            DispatchQueue.main.asyncAfter(deadline: when){
              alert.dismiss(animated: true, completion: nil)
            }
         }) { (error) -> Void in
               print("error: \(error.localizedDescription)")
             let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
             self.present(alert, animated: true, completion: nil)
             let when = DispatchTime.now() + 2
             DispatchQueue.main.asyncAfter(deadline: when){
               alert.dismiss(animated: true, completion: nil)
             }

        }
        
    }
    
    @IBAction func addFile(_ sender: Any) {
        
        var documentPicker: UIDocumentPickerViewController!
        let supportedTypes: [UTType] = [UTType.mp3]
        documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: supportedTypes)
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = false
        documentPicker.modalPresentationStyle = .formSheet
        self.present(documentPicker, animated: true, completion: nil)
    }
    
}

//MARK: UIDocumentPickerDelegate
extension ViewController: UIDocumentPickerDelegate {
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
            var tempURL = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).first!
            //var tempURL = url!
            tempURL.appendPathComponent(externalFileURL.lastPathComponent)
            print("Will attempt to copy file to tempURL = \(tempURL)")
            
            // Attempt copy
            do {
                // If file with same name exists remove it (replace file with new one)
                if FileManager.default.fileExists(atPath: tempURL.path) {
                    print("Deleting existing file at: \(tempURL.path) ")
                    try FileManager.default.removeItem(atPath: tempURL.path)
                }
                
                // Move file from app_id-Inbox to tmp/filename
                print("Attempting move file to: \(tempURL.path) ")
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
            print("fileURL: \(out)")
            mp3URL = out
            do{
                let data = try Data(contentsOf: out)
                if let filename = urls.first?.lastPathComponent {
                    cloudManager.uploadFileToCloud(name: filename, data: data)
                }else{
                    print("no file name")
                }
            }catch{
                print("Error: \(error)")
            }
            
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
