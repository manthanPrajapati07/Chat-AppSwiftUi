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
    
    static let countries: [Country] = [
        Country(name: "India", code: "+91", validNumberCount: 10),
        Country(name: "United States", code: "+1", validNumberCount: 10),
        Country(name: "United Kingdom", code: "+44", validNumberCount: 10),
        Country(name: "Australia", code: "+61", validNumberCount: 9),
        Country(name: "Germany", code: "+49", validNumberCount: 10),
        Country(name: "France", code: "+33", validNumberCount: 9),
        Country(name: "Brazil", code: "+55", validNumberCount: 11),
        Country(name: "Russia", code: "+7", validNumberCount: 10),
        Country(name: "Pakistan", code: "+92", validNumberCount: 10),
        Country(name: "Bangladesh", code: "+880", validNumberCount: 10),
        Country(name: "Canada", code: "+1", validNumberCount: 10),
        Country(name: "China", code: "+86", validNumberCount: 11),
        Country(name: "Japan", code: "+81", validNumberCount: 10),
        Country(name: "Indonesia", code: "+62", validNumberCount: 10),
        Country(name: "Nigeria", code: "+234", validNumberCount: 10),
        Country(name: "Nepal", code: "+977", validNumberCount: 10),
        Country(name: "Sri Lanka", code: "+94", validNumberCount: 9),
        Country(name: "South Korea", code: "+82", validNumberCount: 10),
        Country(name: "South Africa", code: "+27", validNumberCount: 9),
        Country(name: "Malaysia", code: "+60", validNumberCount: 9)]
}

