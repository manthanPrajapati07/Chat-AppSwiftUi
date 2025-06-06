//
//  ChatViewModel.swift
//  WhatsAppClone
//
//  Created by Manthan on 07/06/25.
//

import Foundation

@MainActor
final class ChatViewModel: ObservableObject{
    
    static let shared = ChatViewModel()
    
    private init(){}
    
    func sendMessage(to user: FriendList, text: String) async throws {
        let currentTimeStamp = AppFunctions.getCurrentTimestamp()
        let currentUserId = AppFunctions.getCurrentUserId()
        let chatId = [currentUserId, user.friendId].sorted().joined()
        let messageRef = db.collection("Chats").document(chatId).collection("messages").document()
        
        let message = MessageModel(MessageId: messageRef.documentID, MessageSenderId: currentUserId, MessageReceiverId: user.friendId, MessageText: text, MessageTimestamp: currentTimeStamp, MessageIsSended: true, MessageIsRead: false)

        try messageRef.setData(from: message)
    }
}
