//
//  loginModel.swift
//  WhatsAppClone
//
//  Created by Manthan on 14/05/25.
//

import Foundation

struct Country: Identifiable,Equatable {
    let id = UUID()
    let name: String
    let code: String
    let validNumberCount : Int
}

