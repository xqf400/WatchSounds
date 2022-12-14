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
                        var id = ""
                        if UserDefaults.standard.string(forKey: "adress") != nil{
                            id = UserDefaults.standard.string(forKey: "adress")!
                        }
                        if data != nil {
                            decryptData(ID: id, data: data!) { response in
                                do{
                                    try response.write(to: localURL)
                                    print("wrote \(localURL)")
                                    success(localURL)
                                }catch{
                                    failure(error.localizedDescription)
                                }
                            } failure: { error in
                                failure("Error 99 \(error)")
                            }
                        }else{
                            print("data nil")
                            failure("data nil")
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
    /*
    do {
        let directoryContents = try FileManager.default.contentsOfDirectory(at: soundsURL, includingPropertiesForKeys: nil)
        //print("directoryContents:", directoryContents.map { $0.localizedName ?? $0.lastPathComponent })
        for url1 in directoryContents {
            let filename: NSString = url1.path as NSString
            let pathExtention = filename.pathExtension
            //print(pathExtention)
            if pathExtention == "plist"{
                print(url1.localizedName ?? url1.lastPathComponent)
            }
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
//        for mp3File in mp3s {
//            let url = soundsURL.appendingPathComponent(mp3File)
//            let sound = SoundModel(soundId: soundsNormal.count+1, soundName: mp3File, soundImage: "NoName", soundFile: mp3File, soundVolume: 1.0, soundFileURL: url)
//            soundsNormal.append(sound)
//        }
        
        //writeArrayToFiles()

        
        
        
    } catch {
        print(error)
    }*/
     
    //getSoundFromFiles()
}

func writeArrayToFiles(){
    let encoder = PropertyListEncoder()
    do{
        let data = try encoder.encode(soundsNormal)
        try data.write(to: soundsURL.appendingPathComponent("sounds.plist"))
        print("wrote sounds.plist")
    }catch{
        print("Error encoding plist: \(error)")
    }
}

func getSoundFromFiles(success: @escaping (_ str: String) -> Void, failure: @escaping (_ error: String) -> Void){
    print("get sounds")
    let decoder = PropertyListDecoder()
    do{
        let data = try Data(contentsOf: soundsURL.appendingPathComponent("sounds.plist"))
        do{
            let soundArray = try decoder.decode([SoundModel].self, from: data)
            soundsNormal = soundArray
            soundsNormal = soundsNormal.sorted(by: { $0.soundName < $1.soundName })

//            for sound in soundArray {
//                print("\(sound.soundName) \n\(sound.soundFileURL)")
//            }
            success("got all sounds Count: \(soundsNormal.count)")
        }catch{
            print("Error encoding plist: \(error)")
            failure("Error encoding plist: \(error)")
        }
    }catch{
        print("Error getting data plist: \(error)")
        failure("Error getting data plist: \(error)")
    }

}


func downloadDataFromFireBase(name:String, folder: String, session:URLSession, success: @escaping (_ data: Data) -> Void, failure: @escaping (_ error: String) -> Void){
    
    getTokenFromFirebase(folder: folder, name: name, session: session) { token in
        let urlString = "https://firebasestorage.googleapis.com/v0/b/watchsoundboard.appspot.com/o/"+folder+"%2F"+name+"?alt=media&token="+token
        
        AF.request(urlString)
            .responseData { (response) in
                if response.error != nil{
                    failure("error 55 \(response.error!)")
                }else{
                    if response.response!.statusCode > 300{
                        let error = NSError(domain: urlString, code: response.response!.statusCode, userInfo: nil)
                        failure("error 84 \(error)")
                    }else if response.response!.statusCode == 200{
                        if let data = response.data {
                            switch response.result
                            {
                            case .success(data):
                                var id = ""
                                if UserDefaults.standard.string(forKey: "adress") != nil{
                                    id = UserDefaults.standard.string(forKey: "adress")!
                                }
                                decryptData(ID: id, data: data) { response in
                                    success(response)
                                } failure: { error in
                                    failure("Error 934 \(error)")
                                }
                            case .failure(let error):
                                failure("\(error)")
                            case .success(_):
                                print("suc but not suc")
                                break
                            }
                        }else{
                            failure("dataerror")
                        }
                    }else{
                        failure("Status code \(response.response!.statusCode)")
                        
                    }
                }
            }
    } failure: { error in
        print("Error 1345 \(error)")
        failure("Error 1345 \(error)")
    }
}

func decodeClipFromData(data:Data, success: @escaping (_ user: UserPlist) -> Void, failure: @escaping (_ error: String) -> Void){
    let decoder = PropertyListDecoder()
    do{
        let user1 = try decoder.decode(UserPlist.self, from: data)
        success(user1)
    }catch{
        failure("Error reading: \(error)")
    }
}

//MARK: Date Formatter
func getActualTimeAndDate()->String{
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .medium
    formatter.dateFormat = "d MM yyyy HH:mm:ss"
    formatter.timeZone = TimeZone(abbreviation: "GMT+02:00")
    let formattedString : String = formatter.string(for: Date())!
    return formattedString
}

func getShortTimeAndDateFromDate(date:Date)->String{
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .medium
    formatter.dateFormat = "HH:mm d.MM"
    formatter.timeZone = TimeZone(abbreviation: "GMT+02:00")
    let formattedString : String = formatter.string(for: date)!
    return formattedString
}


func stringToDate(str: String)->Date{
    let formatter = DateFormatter()
    //formatter.dateStyle = .medium
    //formatter.timeStyle = .medium
    formatter.timeZone = TimeZone(abbreviation: "GMT+02:00")
    
    formatter.dateFormat = "d MM yyyy HH:mm:ss"
    let date = formatter.date(from:str)
    if date != nil {
        return date!
    }else{
        print(str)
        return Date()
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


