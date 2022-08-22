//
//  MailAndSecretControllerInterfaceController.swift
//  SoundBoardWatch WatchKit Extension
//
//  Created by Fabian Kuschke on 22.08.22.
//

import WatchKit
import Foundation


class MailAndSecretController: WKInterfaceController {
    
    

    @IBOutlet weak var mailTextField: WKInterfaceTextField!
    @IBOutlet weak var secretTextField: WKInterfaceTextField!
    @IBOutlet weak var checkButtonOutlet: WKInterfaceButton!
    @IBOutlet weak var secretLabel: WKInterfaceLabel!
    @IBOutlet weak var mailLabel: WKInterfaceLabel!
    
    var session : URLSession!
    var mailString: String?
    var secretString: String?
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        session = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: OperationQueue())
        if UserDefaults.standard.string(forKey: "adress") != nil{
            DispatchQueue.main.async {
                let adress = UserDefaults.standard.string(forKey: "adress")
                self.mailLabel.setText("Mail: \(adress!)")
            }
        }else{
            DispatchQueue.main.async {
                self.mailLabel.setText("Mail is empty")
            }
        }
        if UserDefaults.standard.string(forKey: "secret") != nil{
            DispatchQueue.main.async {
                let secret = UserDefaults.standard.string(forKey: "secret")
                self.secretLabel.setText("Secret: \(secret!)")
            }
        }else{
            DispatchQueue.main.async {
                self.secretLabel.setText("Secret is empty")
            }
        }
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    
    @IBAction func mailTextFieldAction(_ value: NSString?) {
        if value != nil {
            mailString = value! as String
            mailLabel.setText(mailString)
        }
    }
    
    @IBAction func secretTextFieldAction(_ value: NSString?) {
        if value != nil {
            secretString = value! as String
            secretLabel.setText(secretString)
        }
    }
    
    @IBAction func checkButtonAction() {
        if secretString != nil && mailString != nil{

            
            downloadDataFromFireBase(name: "\(mailString!).plist", folder: "userLists", session: session) { data in
                print("downloaded plist")
                decodeClipFromData(data: data) { user in
                    if self.secretString == user.secret{
                        UserDefaults.standard.set(self.mailString, forKey: "adress")
                        UserDefaults.standard.set(self.secretString, forKey: "secret")
                        self.secretString = nil
                        self.mailString = nil
                        print("correct secret for mail")
                        self.checkButtonOutlet.setTitle("Correct secret for mail")
                    }else{
                        print("not correct")
                    }
                }failure: { error in
                    print("Error 2 Checking \(error)")
                    DispatchQueue.main.async {
                        //self.testLabel.setText("Error")
                    }
                }
            } failure: { error in
                print("Error 1 Checking \(error)")
                DispatchQueue.main.async {
                    //self.testLabel.setText("Error")
                }
            }

        }else{
            print("empty mail or secret")
        }
    }
}

extension MailAndSecretController: URLSessionDelegate {
    
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
