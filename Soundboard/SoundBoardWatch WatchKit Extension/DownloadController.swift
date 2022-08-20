//
//  DownloadController.swift
//  SoundBoardWatch WatchKit Extension
//
//  Created by Fabian Kuschke on 20.08.22.
//

import Foundation
import WatchKit
import RNCryptor

class DownloadController: WKInterfaceController {
    
    @IBOutlet weak var testLabel: WKInterfaceLabel!
    @IBOutlet weak var volumeView: WKInterfaceVolumeControl!
    
    var soundsURL = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).first!.appendingPathComponent("Soundfiles")
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
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
        volumeView.focus()
        testLabel.setText("Test")
    }
    
    override func willDisappear() {
        volumeView.resignFocus()
    }
    
    override func willActivate() {
        super.willActivate()
    }
    
    @IBAction func downloadButtonAction() {
        print("pressed")
        downloadStringFile { response in
            print("success \(response)")
            
            let songName = "IloveIt.mp3"
//            self.downloadMp3FromFireBase(mp3Name: songName) { url in
//                print(url)
//            } failure: { error in
//                print("Error download mp3 \(error)")
//            }
  
        } failure: { error in
            print("error1: \(error)")
        }

    }
    
    func downloadStringFile(success: @escaping (_ response: String) -> Void, failure: @escaping (_ error: String) -> Void){
        
        
        let url = URL(string: "https://putabeeronit.eu/stringsDict.plist")
        
        let libURL = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).first!
        let fileURL = libURL.appendingPathComponent("stringsDict").appendingPathExtension("plist")
        //    if FileManager.default.fileExists(atPath: fileURL.path) {
        //
        //    }else{
        let sessionConfig = URLSessionConfiguration.default
        let operationQueue = OperationQueue()
        //let session = URLSession(configuration: sessionConfig)
        let session = URLSession(configuration: sessionConfig, delegate: self, delegateQueue: operationQueue)
        
        let request = URLRequest(url:url!)
        
        
        
        let task = session.downloadTask(with: request) { (tempLocalUrl, response, error) in
            if let tempLocalUrl = tempLocalUrl, error == nil {
                //                if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                //                    print("Successfully. Status code: \(statusCode)")
                //                }
                if FileManager.default.fileExists(atPath: fileURL.path){
                    do{
                        try FileManager.default.removeItem(atPath: fileURL.path)
                        //print("deleted because it is already downloaded")
                        do {
                            try FileManager.default.copyItem(at: tempLocalUrl, to: fileURL)
                            let stringDict = NSDictionary(contentsOfFile: fileURL.path)
                            //print(stringDict)
                           let smileString = stringDict!["smileString"] as! String
                            print("Smile2: ", smileString)
                            success("downloaded Strings File")
                        } catch (let error) {
                            print("Error creating a file \(fileURL) : \(error)")
                            failure("Error creating a file \(fileURL) : \(error)")
                        }
                    }catch let error {
                        print("error occurred, here are the details:\n \(error)")
                        failure("error occurred, here are the details:\n \(error)")
                    }
                }else{
                    do {
                        try FileManager.default.copyItem(at: tempLocalUrl, to: fileURL)
                        let stringDict = NSDictionary(contentsOfFile: fileURL.path)
                        //print(stringDict)
                        let smileString = stringDict!["smileString"] as! String
                        print("Smile1: ", smileString)
                        success("downloaded Strings File")
                    } catch (let error) {
                        print("Error creating a file \(fileURL) : \(error)")
                        failure("Error creating a file \(fileURL) : \(error)")
                    }
                }
            }else{
                print("Error took place while downloading a file. Error description: \(error!.localizedDescription)")
                failure("Error took place while downloading a file. Error description: \(error!.localizedDescription)")
            }
        }
        task.resume()
        //}
    }
    
    
    
    
    func getTokenFromFirebase(folder:String, name: String, success: @escaping (_ token: String) -> Void, failure: @escaping (_ error: String) -> Void){
    //https://firebasestorage.googleapis.com/v0/b/watchsoundboard.appspot.com/o/Soundfiles%2FIloveit.mp3?alt=media&token=6a0b10ee-7321-4089-bcd8-f34109861720
        let url = "https://firebasestorage.googleapis.com/v0/b/watchsoundboard.appspot.com/o/"+folder+"%2F" + name
        print("URL: \(url)")
        let sessionConfig = URLSessionConfiguration.default
        let operationQueue = OperationQueue()
        //let session = URLSession(configuration: sessionConfig)
        let session = URLSession(configuration: sessionConfig, delegate: self, delegateQueue: operationQueue)
        let request = URLRequest(url:URL(string: url)!)
    
        let task = session.downloadTask(with: request) { (tempLocalUrl, response, error) in
            //https://firebasestorage.googleapis.com/v0/b/watchsoundboard.appspot.com/o/Soundfiles%2FIloveIt.mp3
        //https://firebasestorage.googleapis.com/v0/b/watchsoundboard.appspot.com/o/Soundfiles%2FIloveit.mp3?alt=media&token=6a0b10ee-7321-4089-bcd8-f34109861720
            print(response)
            print(tempLocalUrl)
            guard let stringDict = NSDictionary(contentsOfFile: tempLocalUrl!.path) else{
                failure("error downloadtoken1")
                return
            }
            
            guard let downloadToken = stringDict["downloadTokens"] as? String else{
                failure("error downloadtoken2")
                return
            }
            success(downloadToken)
        }
        task.resume()
        
        
        
        
        /*
        AF.request(url, method: .get).responseJSON { response in
            //let data: JSON = JSON(response.value)
            if response.response?.statusCode == 200 {
                switch response.result {
                case .success(let value):
                    
                    if let JSON1 = value as? [String: Any] {
                        guard let downloadTokens = JSON1["downloadTokens"] as? String else{
                            failure("error downloadtoken")
                            return
                        }
                        success(downloadTokens)
                    }
                case .failure(let error):
                    myDebug(error.localizedDescription)
                    failure(error.localizedDescription)
                }
            }else{
                myDebug("ErrorSD \(name) \(folder)  \n\(String(describing: response.response?.statusCode))")
                failure("ErrorSD \(name) \(folder)  \n\(String(describing: response.response?.statusCode))")
            }
        }*/
    }
    
    func downloadMp3FromFireBase(mp3Name:String, success: @escaping (_ url: URL) -> Void, failure: @escaping (_ error: String) -> Void){
        let localURL = soundsURL.appendingPathComponent("\(mp3Name)")
        if FileManager.default.fileExists(atPath: localURL.path) {
                success(localURL)

        }else{
            getTokenFromFirebase(folder: "Soundfiles", name: mp3Name) { token in
                print("Got token \(token)")
                let downloadURL = "https://firebasestorage.googleapis.com/v0/b/watchsoundboard.appspot.com/o/Soundfiles%2F"+mp3Name+"?alt=media&token="+token
                let downloadQueue = DispatchQueue(__label: "DownloadSound",attr: nil)
                downloadQueue.async(){
                    
                    let sessionConfig = URLSessionConfiguration.default
                    let operationQueue = OperationQueue()
                    //let session = URLSession(configuration: sessionConfig)
                    let session = URLSession(configuration: sessionConfig, delegate: self, delegateQueue: operationQueue)
                    //let request = URLRequest(url:URL(string: downloadURL)!)
                
                    let task = session.dataTask(with: URL(string: downloadURL)!) { data, response, error in
                        if error != nil {
                            print(error!)
                            failure(error!.localizedDescription)
                        }else{
                            do{
                                try data?.write(to: localURL)
                                print("wrote \(localURL)")
                                success(localURL)
                            }catch{
                                failure(error.localizedDescription)
                            }
                        }
                    }
                    task.resume()
                    
                    
                    
                    /*
                    AF.request(downloadURL,method: .get).response{ response in
                        
                        switch response.result {
                        case .success(let responseData):
                            if responseData != nil {
                                decryptData(ID: "", data: responseData!) { response in
                                    let image = UIImage(data: response)
                                    DispatchQueue.main.async {
                                        do{
                                            try image!.jpegData(compressionQuality: 1)!.write(to: localURL)
                                            success(image)
                                        }catch{
                                            myDebug("image9546411 \(error)")
                                            failure("image9546411 \(error)")
                                        }
                                    }
                                } failure: { error in
                                    myDebug("decryptData34 \(error)")
                                    failure("decryptData34 \(error)")
                                }
                            }
                        case .failure(let error):
                            myDebug("error image 4353511 \(error)")
                            failure("image 43535 \(response.result)")
                        }
                    }.downloadProgress { progress1 in
                        let prog = progress1.fractionCompleted*100
                        let stringValue = String(format: "%.2f", prog)
                        let flo = Float(stringValue)!
                        let intFlo = Int(flo)
                        self.hudDownload.progress = Float(intFlo)/100.0
                        self.hudDownload.detailTextLabel.text = "\(intFlo)% \(downloadedString)"
                        if flo == 100 {
                            //myDebug( "done")
                        }
                    }*/
                    
                    
                    /*
                     AF.request(downloadURL).responseImage { response in
                     if case .success(let image) = response.result {
                     DispatchQueue.main.async {
                     do{
                     try image.jpegData(compressionQuality: 1)!.write(to: localURL)
                     success(image)
                     }catch{
                     myDebug("image9546411 \(error)")
                     failure("image95464 \(error)")
                     }
                     }
                     }else{
                     myDebug("error image 4353511")
                     failure("image 43535 \(response.result)")
                     }
                     }*/
                }
            } failure: { error in
                failure(error)
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
