//
//  Public.swift
//  Soundboard
//
//  Created by Fabian Kuschke on 08.12.21.
//

import Foundation
import AVFoundation
import MediaPlayer
import JGProgressHUD
import Firebase
import FirebaseStorage
import Alamofire

var player: AVAudioPlayer?
let soundVolume:Float = 0.7
var allsSoundArray: [SoundModel] = []

var soundsURL = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).first!.appendingPathComponent("Soundfiles")

//var nluImageNames :[String] = ["nils.png","nils2.png","nils3.png","nils4.png","nils5.png","nils6.png","nils7.png"]
var cachesURL = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).first!
var messagesAreAllowed = false
var playAMessage = false
var playSoundString = ""
var loundSound = true

let Layla = SoundModel(soundId: 55, soundName: "Layla kurz", soundImage: "Layla.png", soundFile: "LaylaKurz", soundVolume: soundVolume, soundFileURL: Bundle.main.url(forResource: "LaylaKurz", withExtension: "mp3")!)

public func addAllSounds(success: @escaping (_ str: String) -> Void, failure: @escaping (_ error: String) -> Void){
    //allsSoundArray.append(Layla)
    
    allsSoundArray.removeAll()
    getSoundFromFiles { str in
        print(str)
        //soundsNormal.append(Layla)
        success(str)
    } failure: { error in
        failure("Error 9667: \(error)")
    }
}

func getSoundFromFiles(success: @escaping (_ str: String) -> Void, failure: @escaping (_ error: String) -> Void){
    let decoder = PropertyListDecoder()
    do{
        let data = try Data(contentsOf: soundsURL.appendingPathComponent("sounds.plist"))
        do{
            let soundArray = try decoder.decode([SoundModel].self, from: data)
            allsSoundArray = soundArray
            allsSoundArray = allsSoundArray.sorted(by: { $0.soundName < $1.soundName })
            success("got all sounds Count: \(allsSoundArray.count)")
        }catch{
            print("Error encoding plist: \(error)")
            failure("Error encoding plist: \(error)")
        }
    }catch{
        print("Error getting data plist: \(error)")
        failure("Error getting data plist: \(error)")
    }
}

func saveSongLocal(song: SoundModel, data:Data, success: @escaping (_ str: String) -> Void, failure: @escaping (_ error: String) -> Void){
    let localURL = soundsURL.appendingPathComponent("\(song.soundFile)")
    if FileManager.default.fileExists(atPath: localURL.path) {
    }else{
        do{
            try data.write(to: localURL)
            print("wrote \(localURL)")
            allsSoundArray.append(song)
            writeArrayToFiles { str in
                success("Wrote array and song")
            } failure: { error in
                print("Error 36 \(error)")
                failure("Error 36 \(error)")
            }
        }catch{
            print("Error 35 \(error.localizedDescription)")
            failure("Error 35 \(error.localizedDescription)")
        }
    }
}
func writeArrayToFiles(success: @escaping (_ str: String) -> Void, failure: @escaping (_ error: String) -> Void){
    let encoder = PropertyListEncoder()
    do{
        let data = try encoder.encode(allsSoundArray)
        try data.write(to: soundsURL.appendingPathComponent("sounds.plist"))
        success("wrote sounds.plist")
    }catch{
        failure("Error encoding plist: \(error)")
    }
}


func createFolder(){
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
}

    
//MARK: Firebase

let storage = Storage.storage()
var db: Firestore! = Firestore.firestore()

//Upload Mp3 file
func uploadToFireBase(fileName:String, data:Data, folder: String, success: @escaping (_ str: String) -> Void, failure: @escaping (_ error: String) -> Void){
    let storageref = storage.reference().child("\(folder)/\(fileName)")
    _ = storageref.putData(data, metadata: nil) { (metadata, error) in
        if error != nil {
            print("Error324 \(error!)")
            failure(error!.localizedDescription)
        }else{
            success("uploaded Image \(fileName)")
        }
    }
}

/*
func saveFavoritesLocal(){
    
    let encoder = PropertyListEncoder()
    let fileURL = cachesURL.appendingPathComponent("favorites").appendingPathExtension("plist")
    do{
        let data = try encoder.encode(favSoundsArray)
        try data.write(to: fileURL)
    }catch{
        print("Error saving dict: \(error)")
    }
    
}*/

/*
func getFavsLocal(){
    if favSoundsArray.count == 0 {
        let fileURL = cachesURL.appendingPathComponent("favorites").appendingPathExtension("plist")
        let filePath = fileURL.path
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: filePath) {
            if let data = try? Data(contentsOf: fileURL){
                let decoder = PropertyListDecoder()
                do{
                    favSoundsArray = try decoder.decode([SoundModel].self, from: data)
                    favSoundsArray = favSoundsArray.sorted(by: { $0.soundName < $1.soundName })
                }catch{
                    print("Error reading: \(error)")
                }
            }else{
                print("no data")
            }
        }else{
            print("favorites not exist")
        }
    }else{
        print("products in products dict vorhanden")
    }
}*/

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



//MARK: JGProgressHUDs
func showHudError(inView: UIViewController, text: String, delay: Double){
    let hud = JGProgressHUD()
    hud.textLabel.text = text
    hud.indicatorView = JGProgressHUDErrorIndicatorView()
    hud.show(in: inView.view, animated: true)
    hud.dismiss(afterDelay: delay)
}
func showHudSuccess(inView: UIViewController, text: String, delay: Double){
    let hud = JGProgressHUD()
    hud.textLabel.text = text
    hud.indicatorView = JGProgressHUDSuccessIndicatorView()
    hud.show(in: inView.view, animated: true)
    hud.dismiss(afterDelay: delay)
}


enum TargetDevice {
    case nativeMac
    case iPad
    case iPhone
    case iWatch
    
    public static var currentDevice: Self {
        var currentDeviceModel = UIDevice.current.model
        #if targetEnvironment(macCatalyst)
        currentDeviceModel = "nativeMac"
        #elseif os(watchOS)
        currentDeviceModel = "watchOS"
        #endif
        
        if currentDeviceModel.starts(with: "iPhone") {
            return .iPhone
        }
        if currentDeviceModel.starts(with: "iPad") {
            return .iPad
        }
        if currentDeviceModel.starts(with: "watchOS") {
            return .iWatch
        }
        return .nativeMac
    }
}


extension UIView{
    func rotate() {
        let rotation : CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        let CounterClockwiseOrClockwise = Bool.random()
        if CounterClockwiseOrClockwise {
            rotation.toValue = Double.pi * 2
        }else{
            rotation.toValue = Double.pi * -2
        }
        let randSpend = Double.random(in: 1..<4)
        rotation.duration = randSpend
        rotation.isCumulative = true
        rotation.repeatCount = Float.greatestFiniteMagnitude
        self.layer.add(rotation, forKey: "rotationAnimation")
    }
}



//MARK: Gif

/*
import UIKit
import ImageIO
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}



extension UIImage {
    
    public class func gifImageWithData(_ data: Data) -> UIImage? {
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else {
            print("image doesn't exist")
            return nil
        }
        
        return UIImage.animatedImageWithSource(source)
    }
    
    public class func gifImageWithURL(_ gifUrl:String) -> UIImage? {
        guard let bundleURL:URL = URL(string: gifUrl)
            else {
                print("image named \"\(gifUrl)\" doesn't exist")
                return nil
        }
        guard let imageData = try? Data(contentsOf: bundleURL) else {
            print("image named \"\(gifUrl)\" into NSData")
            return nil
        }
        
        return gifImageWithData(imageData)
    }
    
    public class func gifImageWithName(_ name: String) -> UIImage? {
        guard let bundleURL = Bundle.main
            .url(forResource: name, withExtension: "gif") else {
                print("SwiftGif: This image named \"\(name)\" does not exist")
                return nil
        }
        guard let imageData = try? Data(contentsOf: bundleURL) else {
            print("SwiftGif: Cannot turn image named \"\(name)\" into NSData")
            return nil
        }
        
        return gifImageWithData(imageData)
    }
    
    class func delayForImageAtIndex(_ index: Int, source: CGImageSource!) -> Double {
        var delay = 0.1
        
        let cfProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil)
        let gifProperties: CFDictionary = unsafeBitCast(
            CFDictionaryGetValue(cfProperties,
                Unmanaged.passUnretained(kCGImagePropertyGIFDictionary).toOpaque()),
            to: CFDictionary.self)
        
        var delayObject: AnyObject = unsafeBitCast(
            CFDictionaryGetValue(gifProperties,
                Unmanaged.passUnretained(kCGImagePropertyGIFUnclampedDelayTime).toOpaque()),
            to: AnyObject.self)
        if delayObject.doubleValue == 0 {
            delayObject = unsafeBitCast(CFDictionaryGetValue(gifProperties,
                Unmanaged.passUnretained(kCGImagePropertyGIFDelayTime).toOpaque()), to: AnyObject.self)
        }
        
        delay = delayObject as! Double
        
        if delay < 0.1 {
            delay = 0.1
        }
        
        return delay
    }
    
    class func gcdForPair(_ a: Int?, _ b: Int?) -> Int {
        var a = a
        var b = b
        if b == nil || a == nil {
            if b != nil {
                return b!
            } else if a != nil {
                return a!
            } else {
                return 0
            }
        }
        
        if a < b {
            let c = a
            a = b
            b = c
        }
        
        var rest: Int
        while true {
            rest = a! % b!
            
            if rest == 0 {
                return b!
            } else {
                a = b
                b = rest
            }
        }
    }
    
    class func gcdForArray(_ array: Array<Int>) -> Int {
        if array.isEmpty {
            return 1
        }
        
        var gcd = array[0]
        
        for val in array {
            gcd = UIImage.gcdForPair(val, gcd)
        }
        
        return gcd
    }
    
    class func animatedImageWithSource(_ source: CGImageSource) -> UIImage? {
        let count = CGImageSourceGetCount(source)
        var images = [CGImage]()
        var delays = [Int]()
        
        for i in 0..<count {
            if let image = CGImageSourceCreateImageAtIndex(source, i, nil) {
                images.append(image)
            }
            
            let delaySeconds = UIImage.delayForImageAtIndex(Int(i),
                source: source)
            delays.append(Int(delaySeconds * 1000.0)) // Seconds to ms
        }
        
        let duration: Int = {
            var sum = 0
            
            for val: Int in delays {
                sum += val
            }
            
            return sum
        }()
        
        let gcd = gcdForArray(delays)
        var frames = [UIImage]()
        
        var frame: UIImage
        var frameCount: Int
        for i in 0..<count {
            frame = UIImage(cgImage: images[Int(i)])
            frameCount = Int(delays[Int(i)] / gcd)
            
            for _ in 0..<frameCount {
                frames.append(frame)
            }
        }
        
        let animation = UIImage.animatedImage(with: frames,
            duration: Double(duration) / 1000.0)
        
        return animation
    }
}*/
