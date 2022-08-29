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
    var creationDate: String
    
    init(id: Int, mail: String, maxFilesCount: Int, uploadedSoundsCount: Int, secret: String, sounds: [String], creationDate: String){
        self.id = id
        self.mail = mail
        self.maxFilesCount = maxFilesCount
        self.uploadedSoundsCount = uploadedSoundsCount
        self.secret = secret
        self.sounds = sounds
        self.creationDate = creationDate
    }
    
    convenience init?(dictionary: [String : Any]) {
        guard
            let id = dictionary["id"] as? Int,
            let maxFilesCount = dictionary["maxFilesCount"] as? Int,
            let uploadedSoundsCount = dictionary["uploadedSoundsCount"] as? Int,
            let secret = dictionary["secret"] as? String,
            let sounds = dictionary["sounds"] as? [String],
            let mail = dictionary["mail"] as? String,
            let creationDate = dictionary["creationDate"] as? String
        else {
            return nil
        }

        self.init(id: id, mail: mail, maxFilesCount: maxFilesCount, uploadedSoundsCount: uploadedSoundsCount, secret: secret, sounds: sounds, creationDate: creationDate)
    }
    
    var dictionary: [String: Any] {
      return [
        "id": id,
        "uploadedSoundsCount": uploadedSoundsCount,
        "maxFilesCount": maxFilesCount,
        "secret": secret,
        "sounds": sounds,
        "mail": mail,
        "creationDate": creationDate,
      ]
    }
    
    func print(){
        Swift.print("id: \(self.id)")
        Swift.print("uploadedSoundsCount: \(self.uploadedSoundsCount)")
        Swift.print("maxFilesCount: \(self.maxFilesCount)")
        Swift.print("secret: \(self.secret)")
        Swift.print("sounds: \(self.sounds)")
        Swift.print("mail: \(self.mail)")
        Swift.print("creationDate: \(self.creationDate)")
    }
    
    
}

class UserPlist: Codable{
    var user: User
    var sounds: [SoundModel]
    
    init(user:User, sounds: [SoundModel]){
        self.user = user
        self.sounds = sounds
    }
    
    convenience init?(dictionary: [String : Any]) {
        guard
            let sounds = dictionary["sounds"] as? [SoundModel],
            let user = dictionary["user"] as? User
        else {
            return nil
        }

        self.init(user: user, sounds: sounds)
    }
    
    var dictionary: [String: Any] {
      return [
        "user": user,
        "sounds": sounds
      ]
    }
    
    
    
}

/*
class UserPlist: Codable{
    
    var id: Int
    var mail: String
    var maxFilesCount: Int
    var uploadedSoundsCount: Int
    var secret: String
    var sounds: [SoundModel]
    var creationDate: Date

    
    init(id: Int, mail: String, maxFilesCount: Int, uploadedSoundsCount: Int, secret: String, sounds: [SoundModel], creationDate: Date){
        self.id = id
        self.mail = mail
        self.maxFilesCount = maxFilesCount
        self.uploadedSoundsCount = uploadedSoundsCount
        self.secret = secret
        self.sounds = sounds
        self.creationDate = creationDate
    }
    
    convenience init?(dictionary: [String : Any]) {
        guard
            let id = dictionary["id"] as? Int,
            let maxFilesCount = dictionary["maxFilesCount"] as? Int,
            let uploadedSoundsCount = dictionary["uploadedSoundsCount"] as? Int,
            let secret = dictionary["secret"] as? String,
            let sounds = dictionary["sounds"] as? [SoundModel],
            let mail = dictionary["mail"] as? String,
            let creationDate = dictionary["creationDate"] as? Date
        else {
            return nil
        }

        self.init(id: id, mail: mail, maxFilesCount: maxFilesCount, uploadedSoundsCount: uploadedSoundsCount, secret: secret, sounds: sounds, creationDate: creationDate)
    }
    
    var dictionary: [String: Any] {
      return [
        "id": id,
        "uploadedSoundsCount": uploadedSoundsCount,
        "maxFilesCount": maxFilesCount,
        "secret": secret,
        "sounds": sounds,
        "mail": mail,
        "creationDate": creationDate
      ]
    }
    
    
}*/
