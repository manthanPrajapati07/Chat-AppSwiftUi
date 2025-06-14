//
//  ChatViewModel.swift
//  WhatsAppClone
//
//  Created by Manthan on 07/06/25.
//

import Foundation
import SwiftUICore

@MainActor
final class ChatViewModel: ObservableObject{
    
    static let shared = ChatViewModel()
    
    private init(){}
    
    @Published var arrMessages : [MessageModel] = []
    @Published var observedFriend: FriendList? = nil
    
    func sendMessage(to user: String, text: String) async throws {
        let currentTimeStamp = AppFunctions.getCurrentTimestamp()
        let currentUserId = AppFunctions.getCurrentUserId()
        let chatId = [currentUserId, user].sorted().joined()
        let messageRef = db.collection("Chats").document(chatId).collection("messages").document()
        
        let message = MessageModel(MessageId: messageRef.documentID, MessageSenderId: currentUserId, MessageReceiverId: user, MessageText: text, MessageTimestamp: currentTimeStamp, MessageIsSended: true, MessageIsRead: false)

        try messageRef.setData(from: message)
    }
    
    
    func listenToMessages(with user: String) {
        let chatId = [AppFunctions.getCurrentUserId(), user].sorted().joined()
        db.collection("Chats").document(chatId).collection("messages")
            .order(by: "MessageTimestamp")
            .addSnapshotListener { snapshot, error in
                guard let documents = snapshot?.documents else { return }
                self.arrMessages = documents.compactMap {
                    try? $0.data(as: MessageModel.self)
                }
            }
    }
    
    
    func listenToFriendDetailChange(with uid: String) {
        db.collection("User").document(uid)
            .addSnapshotListener { documentSnapshot, error in
                guard let document = documentSnapshot, document.exists else {
                    print("Document does not exist or error: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }

                do {
                     let user = try document.data(as: FriendList.self)
                        DispatchQueue.main.async {
                            self.observedFriend = user
                        }
                    
                } catch {
                    print("Failed to decode user: \(error.localizedDescription)")
                }
            }
    }
}
