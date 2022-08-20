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
//        downloadStringFile { response in
//            print("success \(response)")
//
//
//
//        } failure: { error in
//            print("error1: \(error)")
//        }
        
        let sessionConfig = URLSessionConfiguration.default
        let operationQueue = OperationQueue()
        let session = URLSession(configuration: sessionConfig, delegate: self, delegateQueue: operationQueue)
        let songName = "Iloveit.mp3"
        downloadMp3FromFireBase(mp3Name: songName, session: session) { url in
            print(url)

        } failure: { error in
            print("Error download mp3 \(error)")
        }
        

    }
    
    /*
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
    }*/
    
    
    
    
   
    
    
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
