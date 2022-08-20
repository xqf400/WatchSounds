//
//  Encryption.swift
//  Soundboard
//
//  Created by Fabian Kuschke on 20.08.22.
//

import RNCryptor
import Foundation

//ENtschlüssselung
func decryptData(ID: String, data: Data,success: @escaping (_ response: Data) -> (), failure: @escaping (_ error: Error) -> ()){
    let  ass = "ThatsItOrNot2702-90#imroot"
//    if ID == "" {
//        ass = ID
//    }
    do{
        let decData = try RNCryptor.decrypt(data: data, withPassword: ass)
        success(decData)
    }catch{
        print( "en113 \(error)")
        failure(error)
    }
}

//Verschlüsselung
func encryptData(ID: String, data: Data,success: @escaping (_ response: Data) -> (), failure: @escaping (_ error: String) -> ()){
    let  ass = "ThatsItOrNot2702-90#imroot"
//    if ID == "" {
//        ass = ID
//    }

    let encryptedData = RNCryptor.encrypt(data: data, withPassword: ass)
    if !encryptedData.isEmpty{
        success(encryptedData)
    }else{
        failure("123 data is empty")
    }
}

extension String {
    func stringAsData() -> Data{
        let decData: Data = self.data(using: String.Encoding.utf8)!
        return decData
    }
    func dataAsString(data: Data) -> String{
        let str = NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String
        return str
    }
}

