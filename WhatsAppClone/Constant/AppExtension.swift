//
//  File.swift
//  WhatsAppClone
//
//  Created by Manthan on 21/05/25.
//


import Foundation
import UIKit
import SwiftUI

extension String {
    func isEmptyOrWhitespace() -> Bool {
        return self.trimmingCharacters(in: .whitespaces).isEmpty
    }
}
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        
        let r, g, b: Double
        if hex.count == 6 {
            r = Double((int >> 16) & 0xFF) / 255
            g = Double((int >> 8) & 0xFF) / 255
            b = Double(int & 0xFF) / 255
        } else if hex.count == 8 {
            r = Double((int >> 24) & 0xFF) / 255
            g = Double((int >> 16) & 0xFF) / 255
            b = Double((int >> 8) & 0xFF) / 255
        } else {
            r = 0; g = 0; b = 0 // Fallback to black if invalid
        }
        
        self.init(red: r, green: g, blue: b)
    }
}
