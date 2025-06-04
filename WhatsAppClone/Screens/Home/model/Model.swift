//
//  Model.swift
//  WhatsAppClone
//
//  Created by Manthan on 04/06/25.
//

struct AllUserModel : Codable, Hashable{
    var userId: String
    var userAvatar: String
    var userBio: String
    var userEmail: String
    var userName: String
    var userPhone: String
}

extension AllUserModel{
    init?(dictionary: [String : Any], id: String) {
        
        guard   let userId = dictionary["userId"] as? String,
                let userAvatar = dictionary["userAvatar"] as? String,
                let userBio = dictionary["userBio"] as? String,
                let userEmail = dictionary["userEmail"] as? String,
                let userName = dictionary["userName"] as? String,
                let userPhone = dictionary["userPhone"] as? String
        else { return nil }
        
        self.init(userId: userId, userAvatar: userAvatar, userBio: userBio, userEmail: userEmail, userName: userName, userPhone: userPhone)
    }
}
