import Foundation
import Firebase
import FirebaseFirestore
import FirebaseStorage

class FirebaseManager: ObservableObject {
    static let shared = FirebaseManager()
    let db = Firestore.firestore()
    let storage = Storage.storage()
    
    // MARK: - User Operations
    func createUser(userId: String, name: String, email: String, phoneNumber: String, completion: @escaping (Error?) -> Void) {
        let userData: [String: Any] = [
            "userId": userId,
            "name": name,
            "email": email,
            "phoneNumber": phoneNumber,
            "status": "Hey there! I'm using WhatsApp",
            "lastSeen": Timestamp(),
            "profileImageUrl": ""
        ]
        
        db.collection("users").document(userId).setData(userData) { error in
            completion(error)
        }
    }
    
    // MARK: - Chat Operations
    func createChat(participants: [String], completion: @escaping (String?, Error?) -> Void) {
        let chatData: [String: Any] = [
            "participants": participants,
            "createdAt": Timestamp(),
            "type": "private",
            "lastMessage": [
                "text": "",
                "timestamp": Timestamp(),
                "senderId": ""
            ]
        ]
        
        db.collection("chats").addDocument(data: chatData) { error, documentRef in
            if let error = error {
                completion(nil, error)
            } else if let chatId = documentRef?.documentID {
                // Create userChats entries for each participant
                for userId in participants {
                    self.db.collection("userChats").document(userId).collection("chats").document(chatId).setData([
                        "chatId": chatId,
                        "unreadCount": 0,
                        "lastMessage": [
                            "text": "",
                            "timestamp": Timestamp(),
                            "senderId": ""
                        ]
                    ])
                }
                completion(chatId, nil)
            }
        }
    }
    
    // MARK: - Message Operations
    func sendMessage(chatId: String, senderId: String, text: String, type: String = "text", mediaUrl: String? = nil, completion: @escaping (Error?) -> Void) {
        let messageData: [String: Any] = [
            "chatId": chatId,
            "senderId": senderId,
            "text": text,
            "timestamp": Timestamp(),
            "type": type,
            "mediaUrl": mediaUrl ?? "",
            "status": "sent"
        ]
        
        db.collection("messages").addDocument(data: messageData) { error, documentRef in
            if let error = error {
                completion(error)
            } else {
                // Update last message in chat
                self.db.collection("chats").document(chatId).updateData([
                    "lastMessage": [
                        "text": text,
                        "timestamp": Timestamp(),
                        "senderId": senderId
                    ]
                ])
                
                // Update last message in userChats for all participants
                self.db.collection("chats").document(chatId).getDocument { snapshot, error in
                    if let participants = snapshot?.data()?["participants"] as? [String] {
                        for userId in participants {
                            self.db.collection("userChats").document(userId).collection("chats").document(chatId).updateData([
                                "lastMessage": [
                                    "text": text,
                                    "timestamp": Timestamp(),
                                    "senderId": senderId
                                ],
                                "unreadCount": FieldValue.increment(Int64(userId == senderId ? 0 : 1))
                            ])
                        }
                    }
                }
                completion(nil)
            }
        }
    }
    
    // MARK: - Fetch Operations
    func fetchUserChats(userId: String, completion: @escaping ([String: Any]?, Error?) -> Void) {
        db.collection("userChats").document(userId).collection("chats")
            .order(by: "lastMessage.timestamp", descending: true)
            .addSnapshotListener { snapshot, error in
                if let error = error {
                    completion(nil, error)
                    return
                }
                
                var chats: [String: Any] = [:]
                snapshot?.documents.forEach { document in
                    chats[document.documentID] = document.data()
                }
                completion(chats, nil)
            }
    }
    
    func fetchMessages(chatId: String, completion: @escaping ([String: Any]?, Error?) -> Void) {
        db.collection("messages")
            .whereField("chatId", isEqualTo: chatId)
            .order(by: "timestamp", descending: false)
            .addSnapshotListener { snapshot, error in
                if let error = error {
                    completion(nil, error)
                    return
                }
                
                var messages: [String: Any] = [:]
                snapshot?.documents.forEach { document in
                    messages[document.documentID] = document.data()
                }
                completion(messages, nil)
            }
    }
} 