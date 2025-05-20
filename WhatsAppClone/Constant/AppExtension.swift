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
