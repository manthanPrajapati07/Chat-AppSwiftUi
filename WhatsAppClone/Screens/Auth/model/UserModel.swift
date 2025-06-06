//
//  UserModel.swift
//  WhatsAppClone
//
//  Created by Manthan on 21/05/25.
//

import Foundation

struct User : Codable, Equatable, Hashable {
    let userId : String
    let userName : String
    let userPhone : String
    let userBio : String
    let userAvatar : String
    let userEmail : String
    let isUserOnline: Bool
}
extension User{
    init?(dictionary: [String : Any], id: String) {
        
        guard   let userId = dictionary["userId"] as? String,
                let userAvatar = dictionary["userAvatar"] as? String,
                let userBio = dictionary["userBio"] as? String,
                let userEmail = dictionary["userEmail"] as? String,
                let userName = dictionary["userName"] as? String,
                let userPhone = dictionary["userPhone"] as? String,
                let isUserOnline = dictionary["isUserOnline"] as? Bool
        else { return nil }
        
        self.init(userId: userId, userName: userName, userPhone: userPhone, userBio: userBio, userAvatar: userAvatar, userEmail: userEmail, isUserOnline: isUserOnline)
    }
}
