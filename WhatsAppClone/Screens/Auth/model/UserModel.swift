//
//  UserModel.swift
//  WhatsAppClone
//
//  Created by Manthan on 21/05/25.
//

import Foundation

struct User : Identifiable {
    let id : String
    let userName : String
    let userPhone : String
    let userBio : String
    let userAvatar : String
    
    var dictionary : [String : Any] {
        return ["userName": userName,
                "userPhone": userPhone,
                "userBio": userBio,
                "userAvatar": userAvatar]
    }
}
