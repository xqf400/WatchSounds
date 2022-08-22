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
    var secret: String
    var sounds: [String]
    
    init(id: Int, mail: String, maxFilesCount: Int, uploadedSoundsCount: Int, secret: String, sounds: [String]){
        self.id = id
        self.mail = mail
        self.maxFilesCount = maxFilesCount
        self.uploadedSoundsCount = uploadedSoundsCount
        self.secret = secret
        self.sounds = sounds
    }
    
    convenience init?(dictionary: [String : Any]) {
        guard
            let id = dictionary["id"] as? Int,
            let maxFilesCount = dictionary["maxFilesCount"] as? Int,
            let uploadedSoundsCount = dictionary["uploadedSoundsCount"] as? Int,
            let secret = dictionary["secret"] as? String,
            let sounds = dictionary["sounds"] as? [String],
            let mail = dictionary["mail"] as? String else {
            return nil
        }

        self.init(id: id, mail: mail, maxFilesCount: maxFilesCount, uploadedSoundsCount: uploadedSoundsCount, secret: secret, sounds: sounds)
    }
    
    var dictionary: [String: Any] {
      return [
        "id": id,
        "uploadedSoundsCount": uploadedSoundsCount,
        "maxFilesCount": maxFilesCount,
        "secret": secret,
        "sounds": sounds,
        "mail": mail
      ]
    }
    
    
}


class UserPlist: Codable{
    
    var id: Int
    var mail: String
    var maxFilesCount: Int
    var uploadedSoundsCount: Int
    var secret: String
    var sounds: [SoundModel]
    
    init(id: Int, mail: String, maxFilesCount: Int, uploadedSoundsCount: Int, secret: String, sounds: [SoundModel]){
        self.id = id
        self.mail = mail
        self.maxFilesCount = maxFilesCount
        self.uploadedSoundsCount = uploadedSoundsCount
        self.secret = secret
        self.sounds = sounds
    }
    
    convenience init?(dictionary: [String : Any]) {
        guard
            let id = dictionary["id"] as? Int,
            let maxFilesCount = dictionary["maxFilesCount"] as? Int,
            let uploadedSoundsCount = dictionary["uploadedSoundsCount"] as? Int,
            let secret = dictionary["secret"] as? String,
            let sounds = dictionary["sounds"] as? [SoundModel],
            let mail = dictionary["mail"] as? String else {
            return nil
        }

        self.init(id: id, mail: mail, maxFilesCount: maxFilesCount, uploadedSoundsCount: uploadedSoundsCount, secret: secret, sounds: sounds)
    }
    
    var dictionary: [String: Any] {
      return [
        "id": id,
        "uploadedSoundsCount": uploadedSoundsCount,
        "maxFilesCount": maxFilesCount,
        "secret": secret,
        "sounds": sounds,
        "mail": mail
      ]
    }
    
    
}
