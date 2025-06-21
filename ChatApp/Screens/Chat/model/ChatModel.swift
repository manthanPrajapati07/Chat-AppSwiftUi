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
extension MessageModel{
    init?(dictionary: [String : Any], id: String) {
        
        guard   let MessageId = dictionary["MessageId"] as? String,
                let MessageSenderId = dictionary["MessageSenderId"] as? String,
                let MessageReceiverId = dictionary["MessageReceiverId"] as? String,
                let MessageText = dictionary["MessageText"] as? String,
                let MessageTimestamp = dictionary["MessageTimestamp"] as? Int,
                let MessageIsSended = dictionary["MessageIsSended"] as? Bool,
                let MessageIsRead = dictionary["MessageIsRead"] as? Bool
                
        else { return nil }
        
        self.init(MessageId: MessageId, MessageSenderId: MessageSenderId, MessageReceiverId: MessageReceiverId, MessageText: MessageText, MessageTimestamp: MessageTimestamp, MessageIsSended: MessageIsSended, MessageIsRead: MessageIsRead)
    }
}

struct MessageTimeStamp {
    let date: String
    let day: String
    let time: String
}
