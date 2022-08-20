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
    var sounds: [String]
    
    init(id: Int, mail: String, maxFilesCount: Int, sounds: [String]){
        self.id = id
        self.mail = mail
        self.maxFilesCount = maxFilesCount
        self.sounds = sounds
    }
    
    convenience init?(dictionary: [String : Any]) {
        guard
            let id = dictionary["id"] as? Int,
            let maxFilesCount = dictionary["maxFilesCount"] as? Int,
            let sounds = dictionary["sounds"] as? [String],
            let mail = dictionary["mail"] as? String else {
            return nil
        }

        self.init(id: id, mail: mail, maxFilesCount: maxFilesCount, sounds: sounds)
    }
    
    var dictionary: [String: Any] {
      return [
        "id": id,
        "maxFilesCount": maxFilesCount,
        "sounds": sounds,
        "mail": mail
      ]
    }
    
    
}
