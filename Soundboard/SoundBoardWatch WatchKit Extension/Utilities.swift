//
//  Utilities.swift
//  SoundBoardWatch WatchKit Extension
//
//  Created by Fabian Kuschke on 20.08.22.
//

import Foundation
import UIKit
import Alamofire

var soundsURL = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).first!.appendingPathComponent("Soundfiles")
var soundsNormal : [SoundModel] = []


//MARK: Get token firebase
func getTokenFromFirebase(folder:String, name: String, session: URLSession, success: @escaping (_ token: String) -> Void, failure: @escaping (_ error: String) -> Void){
    let url = "https://firebasestorage.googleapis.com/v0/b/watchsoundboard.appspot.com/o/"+folder+"%2F" + name
    
    AF.request(url, method: .get).responseJSON { response in
        //let data: JSON = JSON(response.value)
        if response.response?.statusCode == 200 {
            switch response.result {
            case .success(let value):
                
                if let JSON1 = value as? [String: Any] {
                    guard let downloadTokens = JSON1["downloadTokens"] as? String else{
                        failure("error downloadtoken \(JSON1)")
                        return
                    }
                    success(downloadTokens)
                }else{
                    failure("Error json1")
                }
            case .failure(let error):
                print(error.localizedDescription)
                failure(error.localizedDescription)
            }
        }else{
            print("ErrorSD \(name) \(folder)  \n\(String(describing: response.response?.statusCode))")
            failure("ErrorSD \(name) \(folder)  \n\(String(describing: response.response?.statusCode))")
        }
    }
    
    
}

//MARK: Download Mp3 firebase
func downloadMp3FromFireBase(mp3Name:String, session: URLSession, success: @escaping (_ url: URL) -> Void, failure: @escaping (_ error: String) -> Void){
    let localURL = soundsURL.appendingPathComponent("\(mp3Name)")
    if FileManager.default.fileExists(atPath: localURL.path) {
        success(localURL)
        
    }else{
        getTokenFromFirebase(folder: "Soundfiles", name: mp3Name, session: session) { token in
            let downloadURL = "https://firebasestorage.googleapis.com/v0/b/watchsoundboard.appspot.com/o/Soundfiles%2F"+mp3Name+"?alt=media&token="+token
            let downloadQueue = DispatchQueue(__label: "DownloadSound",attr: nil)
            downloadQueue.async(){
                
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
                
            }
        } failure: { error in
            failure(error)
        }
    }
}

//MARK: Get local mp3 files
func getLocalFiles(){
    
    do {
        let directoryContents = try FileManager.default.contentsOfDirectory(at: soundsURL, includingPropertiesForKeys: nil)
        //print("directoryContents:", directoryContents.map { $0.localizedName ?? $0.lastPathComponent })
        //                    for url1 in directoryContents {
        //
        //                        print(url1.localizedName ?? url1.lastPathComponent)
        //                    }
        
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
            let url = soundsURL.appendingPathComponent(mp3File)
            let sound = SoundModel(soundId: soundsNormal.count+1, soundName: mp3File, soundImage: "Layla.png", soundFile: mp3File, soundVolume: 1.0, soundFileURL: url)
            soundsNormal.append(sound)
        }
        
    } catch {
        print(error)
    }
}


//MARK: Extension URL
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
