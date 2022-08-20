//
//  User.swift
//  Soundboard
//
//  Created by Fabian Kuschke on 20.08.22.
//

import Foundation

class User: Codable{
    
    var id: Int
    var mail: String
    var maxFilesCount: Int
    var uploadedSoundsCount: Int
    var sounds: [String]
    
    init(id: Int, mail: String, maxFilesCount: Int, uploadedSoundsCount: Int, sounds: [String]){
        self.id = id
        self.mail = mail
        self.maxFilesCount = maxFilesCount
        self.uploadedSoundsCount = uploadedSoundsCount
        self.sounds = sounds
    }
    
    convenience init?(dictionary: [String : Any]) {
        guard
            let id = dictionary["id"] as? Int,
            let maxFilesCount = dictionary["maxFilesCount"] as? Int,
            let uploadedSoundsCount = dictionary["uploadedSoundsCount"] as? Int,
            let sounds = dictionary["sounds"] as? [String],
            let mail = dictionary["mail"] as? String else {
            return nil
        }

        self.init(id: id, mail: mail, maxFilesCount: maxFilesCount, uploadedSoundsCount: uploadedSoundsCount, sounds: sounds)
    }
    
    var dictionary: [String: Any] {
      return [
        "id": id,
        "uploadedSoundsCount": uploadedSoundsCount,
        "maxFilesCount": maxFilesCount,
        "sounds": sounds,
        "mail": mail
      ]
    }
    
    
}
