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
}
