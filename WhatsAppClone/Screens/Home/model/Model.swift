//
//  Model.swift
//  WhatsAppClone
//
//  Created by Manthan on 04/06/25.
//

//struct AllUserModel : Codable, Hashable{
//    var userId: String
//    var userAvatar: String
//    var userBio: String
//    var userEmail: String
//    var userName: String
//    var userPhone: String
//}
//
//extension AllUserModel{
//    init?(dictionary: [String : Any], id: String) {
//        
//        guard   let userId = dictionary["userId"] as? String,
//                let userAvatar = dictionary["userAvatar"] as? String,
//                let userBio = dictionary["userBio"] as? String,
//                let userEmail = dictionary["userEmail"] as? String,
//                let userName = dictionary["userName"] as? String,
//                let userPhone = dictionary["userPhone"] as? String
//        else { return nil }
//        
//        self.init(userId: userId, userAvatar: userAvatar, userBio: userBio, userEmail: userEmail, userName: userName, userPhone: userPhone)
//    }
//}

struct FriendList: Codable, Equatable, Hashable{
    let friendId: String
    let friendAvatar: String
    let friendBio: String
    let friendEmail: String
    let friendName: String
    let friendPhone: String
    let isFriendOnline: Bool
    let friendshipCreatedTime: Int
    let lastMassageTime: Int
    let lastMassage: String
}

extension FriendList{
    init?(dictionary: [String : Any], id: String) {
        
        guard   let friendId = dictionary["friendId"] as? String,
                let friendAvatar = dictionary["friendAvatar"] as? String,
                let friendBio = dictionary["friendBio"] as? String,
                let friendEmail = dictionary["friendEmail"] as? String,
                let friendName = dictionary["friendName"] as? String,
                let friendPhone = dictionary["friendPhone"] as? String,
                let isFriendOnline = dictionary["isFriendOnline"] as? Bool,
                let friendshipCreatedTime = dictionary["friendshipCreatedTime"] as? Int,
                let lastMassageTime = dictionary["lastMassageTime"] as? Int,
                let lastMassage = dictionary["lastMassage"] as? String
                    
        else { return nil }
        
        self.init(friendId: friendId, friendAvatar: friendAvatar, friendBio: friendBio, friendEmail: friendEmail, friendName: friendName, friendPhone: friendPhone, isFriendOnline: isFriendOnline, friendshipCreatedTime: friendshipCreatedTime, lastMassageTime: lastMassageTime, lastMassage: lastMassage)
    }
}

