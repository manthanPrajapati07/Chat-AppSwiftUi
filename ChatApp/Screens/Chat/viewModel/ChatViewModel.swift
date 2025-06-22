//
//  ChatViewModel.swift
//  WhatsAppClone
//
//  Created by Manthan on 07/06/25.
//

import Foundation
import SwiftUICore
import Firebase

@MainActor
final class ChatViewModel: ObservableObject{
    
    static let shared = ChatViewModel()
    
    private init(){}
    
    @Published var arrMessages : [MessageModel] = []
    @Published var observedFriend: User? = nil
    @Published var userDetailFound: Bool = false
    
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
                Task{
                    if let lastMessage = self.arrMessages.last{
                        await self.updateLastMesssageInFirestore(uid: user, lastMessage: lastMessage)
                    }
                }
                
            }
    }
    
    
    func listenToFriendDetailChange(with uid: String) {
        db.collection("User").document(uid)
            .addSnapshotListener { documentSnapshot, error in
                guard let document = documentSnapshot, document.exists else {
                    print(error?.localizedDescription ?? "Unknown error")
                    return
                }

                do {
                     let user = try document.data(as: User.self)
                        DispatchQueue.main.async {
                            self.observedFriend = user
                            self.userDetailFound = true
                        }
                    
                } catch {
                    print(error.localizedDescription)
                }
            }
    }
    
//    
//    func updateLastMesssageInFirestore(uid : String, lastMessage: MessageModel) async {
//        
//        do{
//            let encodedMessage = try Firestore.Encoder().encode(lastMessage)
//            
//            do {
//                try await db
//                    .collection("Friends")
//                    .document(AppFunctions.getCurrentUserId())
//                    .collection("FriendList")
//                    .document(uid)
//                    .updateData([
//                        "lastMassage": encodedMessage,
//                        "lastMassageTime":lastMessage.MessageTimestamp
//                    ])
//            }
//            catch{
//                print(error.localizedDescription)
//            }
//        }
//        catch{
//            print(error.localizedDescription)
//        }
//    }
    
    func updateLastMesssageInFirestore(uid: String, lastMessage: MessageModel) async {
        do {
            let encodedMessage = try Firestore.Encoder().encode(lastMessage)
            let update: [String: Any] = [
                "lastMassage": encodedMessage,
                "lastMassageTime": lastMessage.MessageTimestamp
            ]

            let currentUserId = AppFunctions.getCurrentUserId()

            try await db
                .collection("Friends")
                .document(currentUserId)
                .collection("FriendList")
                .document(uid)
                .updateData(update)

            try await db
                .collection("Friends")
                .document(uid)
                .collection("FriendList")
                .document(currentUserId)
                .updateData(update)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    
    func updateTypingStatus(uid: String, isTypingStatus: Bool) async {
        do {
            let update: [String: Any] = [
                "isFriendTyping": isTypingStatus
            ]

            let currentUserId = AppFunctions.getCurrentUserId()

//            try await db
//                .collection("Friends")
//                .document(currentUserId)
//                .collection("FriendList")
//                .document(uid)
//                .updateData(update)

            try await db
                .collection("Friends")
                .document(uid)
                .collection("FriendList")
                .document(currentUserId)
                .updateData(update)
            
        } catch {
            print(error.localizedDescription)
        }
    }

    
    func setMesssageRead(to user: String, messageId: String) async {
        let currentTimeStamp = AppFunctions.getCurrentTimestamp()
        let currentUserId = AppFunctions.getCurrentUserId()
        let chatId = [currentUserId, user].sorted().joined()
        let messageRef = db.collection("Chats").document(chatId).collection("messages").document(messageId)
        
        let updateMessage : [String : Any] = [
            "MessageIsRead" : true
        ]
        do{
            try await messageRef.updateData(updateMessage)
        }
        catch{
            print(error.localizedDescription)
        }
    }
}
