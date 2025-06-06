//
//  ChatModel.swift
//  WhatsAppClone
//
//  Created by Manthan on 06/06/25.
//

import Foundation

struct MessageModel: Codable, Equatable, Hashable{
    var MessageId: String
    var MessageSenderId: String
    var MessageReceiverId: String
    var MessageText: String
    var MessageTimestamp: Int
    var MessageIsSended: Bool = false
    var MessageIsRead: Bool
}
