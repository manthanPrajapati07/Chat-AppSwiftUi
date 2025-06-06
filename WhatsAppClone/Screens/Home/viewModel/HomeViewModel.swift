//
//  HomeViewModel.swift
//  WhatsAppClone
//
//  Created by Manthan on 24/05/25.
//

import Foundation
import SwiftUI
import FirebaseFirestore

@MainActor
final class HomeViewModel : ObservableObject{
    
    static let shared = HomeViewModel()
    private init(){}
    
    let segmentArrey = ["Explore", "Friends"]
    
    @Published var arrExploreUsers : [User] = []
    @Published var arrUserFriend : [FriendList] = []
    
    
    func fetchUsers() {
        Task {
            AppFunctions.showLoader()
            
            do {
                // Step 1: Fetch Friends
                let friendSnapshot = try await db
                    .collection("Friends")
                    .document(AppFunctions.getCurrentUserId())
                    .collection("FriendList")
                    .getDocuments()
                
                let fetchedFriends = friendSnapshot.documents.compactMap { doc -> FriendList? in
                    FriendList(dictionary: doc.data(), id: doc.documentID)
                }
                
                self.arrUserFriend = fetchedFriends
                
                // Step 2: Fetch All Users
                let exploreSnapshot = try await db
                    .collection("User")
                    .getDocuments()
                
                let allUsers = exploreSnapshot.documents.compactMap { doc -> User? in
                    User(dictionary: doc.data(), id: doc.documentID)
                }
                
                let filteredUsers = allUsers.filter { $0.userId != AppFunctions.getCurrentUserId() }
                let friendIds = self.arrUserFriend.map { $0.friendId }
                self.arrExploreUsers = filteredUsers.filter { !friendIds.contains($0.userId) }

            } catch {
                print("Error in fetchUsers(): \(error.localizedDescription)")
            }
            
            AppFunctions.hideLoader()
        }
    }
    
    
//    func addFriend(to user: User){
//        AppFunctions.showLoader()
//        let timestamp = AppFunctions.getCurrentTimestamp()
//        
//        if let currentUserDetail = AppFunctions.getCurrentUserDetail(){
//            
//            let friend = FriendList(friendId: user.userId, friendAvatar: user.userAvatar, friendBio: user.userBio, friendEmail: user.userEmail, friendName: user.userName, friendPhone: user.userPhone, isFriendOnline: user.isUserOnline, friendshipCreatedTime: timestamp, lastMassageTime: timestamp, lastMassage: "Start chat With \(user.userName)")
//            
//            let reverseFriendToUser = FriendList(friendId: currentUserDetail.userId, friendAvatar: currentUserDetail.userAvatar, friendBio: currentUserDetail.userBio, friendEmail: currentUserDetail.userEmail, friendName: currentUserDetail.userName, friendPhone: currentUserDetail.userPhone, isFriendOnline: currentUserDetail.isUserOnline, friendshipCreatedTime: timestamp, lastMassageTime: timestamp, lastMassage: "Start chat With \(currentUserDetail.userName)")
//            
//            AppFunctions.hideLoader()
//            do{
//                try db
//                    .collection("Friends")
//                    .document(AppFunctions.getCurrentUserId())
//                    .collection("FriendList")
//                    .document(user.userId)
//                    .setData(from: friend)
//                
//                try db
//                    .collection("Friends")
//                    .document(user.userId)
//                    .collection("FriendList")
//                    .document(AppFunctions.getCurrentUserId())
//                    .setData(from: reverseFriendToUser)
//                
//                AppFunctions.ShowToast(massage: "\(user.userName) is added in your friends", duration: 1.0)
//                
//                fetchUsers()
//            }
//            catch{
//                AppFunctions.ShowToast(massage: error.localizedDescription, duration: 1.0)
//            }
//        }
//    }
    
    func addFriend(to user: User) {
        Task {
            AppFunctions.showLoader()
            let timestamp = AppFunctions.getCurrentTimestamp()
            
            if let currentUserDetail = AppFunctions.getCurrentUserDetail() {
                
                let friend = FriendList(friendId: user.userId, friendAvatar: user.userAvatar, friendBio: user.userBio, friendEmail: user.userEmail, friendName: user.userName, friendPhone: user.userPhone, isFriendOnline: user.isUserOnline, friendshipCreatedTime: timestamp, lastMassageTime: timestamp, lastMassage: "Start chat With \(user.userName)")
                
                let reverseFriendToUser = FriendList(friendId: currentUserDetail.userId, friendAvatar: currentUserDetail.userAvatar, friendBio: currentUserDetail.userBio, friendEmail: currentUserDetail.userEmail, friendName: currentUserDetail.userName, friendPhone: currentUserDetail.userPhone, isFriendOnline: currentUserDetail.isUserOnline, friendshipCreatedTime: timestamp, lastMassageTime: timestamp, lastMassage: "Start chat With \(currentUserDetail.userName)")
                
                do {
                    try db
                        .collection("Friends")
                        .document(AppFunctions.getCurrentUserId())
                        .collection("FriendList")
                        .document(user.userId)
                        .setData(from: friend)

                    try db
                        .collection("Friends")
                        .document(user.userId)
                        .collection("FriendList")
                        .document(AppFunctions.getCurrentUserId())
                        .setData(from: reverseFriendToUser)
                    
                    AppFunctions.ShowToast(massage: "\(user.userName) is added in your friends", duration: 1.0)
                    
                     fetchUsers()

                } catch {
                    AppFunctions.ShowToast(massage: error.localizedDescription, duration: 1.0)
                }
            }
            AppFunctions.hideLoader()
        }
    }
}


