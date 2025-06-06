//
//  Model.swift
//  WhatsAppClone
//
//  Created by Manthan on 04/06/25.
//

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

