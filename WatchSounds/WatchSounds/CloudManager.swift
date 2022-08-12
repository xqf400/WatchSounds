//
//  CloudManager.swift
//  WatchSounds
//
//  Created by Fabian Kuschke on 10.08.22.
//

import Foundation
//import CloudKit




class CloudDataManager {

    static let sharedInstance = CloudDataManager() // Singleton

    struct DocumentsDirectory {
        static let localDocumentsURL = FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: .userDomainMask).last!
        static let iCloudDocumentsURL = FileManager.default.url(forUbiquityContainerIdentifier: nil)?.appendingPathComponent("Documents")
    }


    // Return the Document directory (Cloud OR Local)
    // To do in a background thread

    func getDocumentDiretoryURL() -> URL {
        if isCloudEnabled()  {
            return DocumentsDirectory.iCloudDocumentsURL!
        } else {
            return DocumentsDirectory.localDocumentsURL
        }
    }

    // Return true if iCloud is enabled

    func isCloudEnabled() -> Bool {
        if DocumentsDirectory.iCloudDocumentsURL != nil { return true }
        else {
            return false            
        }
    }

    // Delete All files at URL

    func deleteFilesInDirectory(url: URL?) {
        let fileManager = FileManager.default
        let enumerator = fileManager.enumerator(atPath: url!.path)
        while let file = enumerator?.nextObject() as? String {

            do {
                try fileManager.removeItem(at: url!.appendingPathComponent(file))
                print("Files deleted")
            } catch let error as NSError {
                print("Failed deleting files : \(error)")
            }
        }
    }

    // Copy local files to iCloud
    // iCloud will be cleared before any operation
    // No data merging

    func copyFileToCloud() {
        if isCloudEnabled() {
            deleteFilesInDirectory(url: DocumentsDirectory.iCloudDocumentsURL!) // Clear all files in iCloud Doc Dir
            let fileManager = FileManager.default
            let enumerator = fileManager.enumerator(atPath: DocumentsDirectory.localDocumentsURL.path)
            while let file = enumerator?.nextObject() as? String {

                do {
                    try fileManager.copyItem(at: DocumentsDirectory.localDocumentsURL.appendingPathComponent(file), to: DocumentsDirectory.iCloudDocumentsURL!.appendingPathComponent(file))

                    print("Copied to iCloud")
                } catch let error as NSError {
                    print("Failed to move file to Cloud : \(error)")
                }
            }
        }
    }
    
    func uploadFileToCloud(name: String, data: Data){
//        do {
//            try data.write(to: DocumentsDirectory.iCloudDocumentsURL!)
//            print("uploaded to iCloud")
//        } catch let error as NSError {
//            print("Failed to move file to Cloud : \(error)")
//        }
        
        
        
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first{
            let myLocalFile = dir.appendingPathComponent(name)
            do {
                try data.write(to: myLocalFile)
            }
            catch {
                print(error.localizedDescription)
            }
            var isDir:ObjCBool = false
            if (FileManager.default.fileExists(atPath: DocumentsDirectory.iCloudDocumentsURL!.path, isDirectory: &isDir)) {
                do {
                    try FileManager.default.removeItem(at: DocumentsDirectory.iCloudDocumentsURL!)
                    print("removed Item")
                }
                catch {
                    print(error.localizedDescription)
                }
            }else{
                print("not")
            }
            //copy from my local to iCloud
            do {
                try FileManager.default.copyItem(at: DocumentsDirectory.localDocumentsURL, to: DocumentsDirectory.iCloudDocumentsURL!)
                print("uploaded \(name)")
            }
            catch {
                print(error.localizedDescription)
            }
        }
    }

    // Copy iCloud files to local directory
    // Local dir will be cleared
    // No data merging

    func copyFileToLocal() {
        if isCloudEnabled() {
            deleteFilesInDirectory(url: DocumentsDirectory.localDocumentsURL)
            let fileManager = FileManager.default
            let enumerator = fileManager.enumerator(atPath: DocumentsDirectory.iCloudDocumentsURL!.path)
            while let file = enumerator?.nextObject() as? String {

                do {
                    try fileManager.copyItem(at: DocumentsDirectory.iCloudDocumentsURL!.appendingPathComponent(file), to: DocumentsDirectory.localDocumentsURL.appendingPathComponent(file))

                    print("Moved to local dir")
                } catch let error as NSError {
                    print("Failed to move file to local dir : \(error)")
                }
            }
        }
    }

    
    func enableCloudExample(){
        if let url = DocumentsDirectory.iCloudDocumentsURL, !FileManager.default.fileExists(atPath: url.path, isDirectory: nil) {
                    do {
                        try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
                        print(1)
                    }
                    catch {
                        print(2)
                        print(error.localizedDescription)
                    }
                }else{
                    print(3)
                    do {
                        try FileManager.default.createDirectory(at: DocumentsDirectory.iCloudDocumentsURL!, withIntermediateDirectories: true, attributes: nil)
                        print(1)
                    }
                    catch {
                        print(2)
                    }
        
                }
        
                let myTextString = NSString(string: "HELLO WORLD")
                if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first{
                    let myLocalFile = dir.appendingPathComponent("myTextFile.txt")
                    do {
                        try myTextString.write(to: myLocalFile, atomically: true, encoding: String.Encoding.utf8.rawValue)
                    }
                    catch {
                        print(error.localizedDescription)
                    }
                    var isDir:ObjCBool = false
                    if (FileManager.default.fileExists(atPath: DocumentsDirectory.iCloudDocumentsURL!.path, isDirectory: &isDir)) {
                        do {
                            try FileManager.default.removeItem(at: DocumentsDirectory.iCloudDocumentsURL!)
                            print("removeItem")
                        }
                        catch {
                            print(error.localizedDescription)
                        }
                    }else{
                        print("not")
                    }
                    //copy from my local to iCloud
                    do {
                        try FileManager.default.copyItem(at: DocumentsDirectory.localDocumentsURL, to: DocumentsDirectory.iCloudDocumentsURL!)
                        print("copyItem")
                    }
                    catch {
                        print(error.localizedDescription)
                    }
                }
    }


}
