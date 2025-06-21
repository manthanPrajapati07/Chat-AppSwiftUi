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
    
    private init(){
        reset()
    }
    
    let segmentArrey = ["Explore", "Friends"]
    
    @Published var arrExploreUsers : [User] = []
    @Published var arrUserFriend : [FriendList] = []
    @Published var selectedFriend: FriendList? = nil
    
    private var activeFriendListeners: [String: ListenerRegistration] = [:]
    private var userListener: ListenerRegistration? = nil

    func observeExploreUsers() {
        let currentUserId = AppFunctions.getCurrentUserId()
        
        userListener?.remove()
        
        userListener = db.collection("User").addSnapshotListener { snapshot, error in
            if let error = error {
                print("❌ Error listening to User collection: \(error.localizedDescription)")
                return
            }

            guard let documents = snapshot?.documents else {
                print("⚠️ No user documents found")
                return
            }

            let allUsers = documents.compactMap { doc -> User? in
                User(dictionary: doc.data(), id: doc.documentID)
            }

            let filteredUsers = allUsers.filter { $0.userId != currentUserId }
            let friendIds = self.arrUserFriend.map { $0.friendId }

            DispatchQueue.main.async {
                self.arrExploreUsers = filteredUsers.filter { !friendIds.contains($0.userId) }
                print("✅ Explore users updated with listener")
            }
        }
    }

    
    
    func addFriend(to user: User) {
        Task {
            AppFunctions.showLoader()
            let timestamp = AppFunctions.getCurrentTimestamp()
            
            if let currentUserDetail = AppFunctions.getCurrentUserDetail() {
                
                let friend = FriendList(friendId: user.userId, friendAvatar: user.userAvatar, friendBio: user.userBio, friendEmail: user.userEmail, friendName: user.userName, friendPhone: user.userPhone, isFriendOnline: user.isUserOnline, isFriendTyping: false, friendshipCreatedTime: timestamp, lastMassageTime: timestamp, lastMassage: nil)
                
                let reverseFriendToUser = FriendList(friendId: currentUserDetail.userId, friendAvatar: currentUserDetail.userAvatar, friendBio: currentUserDetail.userBio, friendEmail: currentUserDetail.userEmail, friendName: currentUserDetail.userName, friendPhone: currentUserDetail.userPhone, isFriendOnline: currentUserDetail.isUserOnline, isFriendTyping: false, friendshipCreatedTime: timestamp, lastMassageTime: timestamp, lastMassage: nil)
                
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
                    
                    self.arrUserFriend.append(friend)
                    observeExploreUsers()

                } catch {
                    AppFunctions.ShowToast(massage: error.localizedDescription, duration: 1.0)
                }
            }
            AppFunctions.hideLoader()
        }
    }
    func observeUserFriends() {
        let userId = AppFunctions.getCurrentUserId()

        db.collection("Friends")
            .document(userId)
            .collection("FriendList")
            .addSnapshotListener { snapshot, error in
                print("👀 observeUserFriends fired!")
                if let error = error {
                    print("❌ Error fetching FriendList: \(error.localizedDescription)")
                    return
                }

                guard let documents = snapshot?.documents else {
                    print("⚠️ No friend documents found")
                    return
                }

                let fetchedFriends: [FriendList] = documents.compactMap {
                    FriendList(dictionary: $0.data(), id: $0.documentID)
                }

                DispatchQueue.main.async {
                    self.arrUserFriend = fetchedFriends
                    
                    for friend in fetchedFriends {
                        self.listenToFriendDocument(friendId: friend.friendId)
                    }
                }
                self.observeExploreUsers()
            }
    }


    func listenToFriendDocument(friendId: String) {
        
        if activeFriendListeners[friendId] != nil { return }

        let currentUserId = AppFunctions.getCurrentUserId()

        let listener = db.collection("Friends")
            .document(currentUserId)
            .collection("FriendList")
            .document(friendId)
            .addSnapshotListener { documentSnapshot, error in
                print("📥 Document listener fired for \(friendId)")
                guard let document = documentSnapshot, document.exists,
                      let updatedFriend = FriendList(dictionary: document.data()!, id: friendId) else {
                    print("⚠️ Failed to update friend: \(friendId)")
                    return
                }

                DispatchQueue.main.async {
                    if let index = self.arrUserFriend.firstIndex(where: { $0.friendId == friendId }) {
                        self.arrUserFriend[index] = updatedFriend
                        print("✅ LIVE UPDATE for \(friendId): \(updatedFriend.lastMassage?.MessageText ?? "nil")")
                        print("✅ LIVE UPDATE for \(friendId): \(updatedFriend.isFriendTyping)")
                    }
                }
            }

        activeFriendListeners[friendId] = listener
    }
    
    func updateMyProfileAvatar(newAvatar: UserAvatarsList?) async {
        guard let newAvatar else{return}

        do{
            try await db.collection("User")
                .document(AppFunctions.getCurrentUserId())
                .updateData(["userAvatar": newAvatar.avatarName])
        }catch{
            print(error.localizedDescription)
        }
        do{
            let friendSnapshot = try await db
                .collection("Friends")
                .document(AppFunctions.getCurrentUserId())
                .collection("FriendList")
                .getDocuments()
            
            let myInfo = AppFunctions.getCurrentUserDetail()
            
            for doc in friendSnapshot.documents {
                let friendId = doc.documentID
                
                try await db
                    .collection("Friends")
                    .document(friendId)
                    .collection("FriendList")
                    .document(AppFunctions.getCurrentUserId())
                    .updateData([
                        "friendAvatar": newAvatar.avatarName,
                    ])
            }
        }
        catch{
            print(error.localizedDescription)
        }
    }
   
    func reset() {
        arrExploreUsers.removeAll()
        arrUserFriend.removeAll()
        selectedFriend = nil
        
        // Remove all listeners
        for (_, listener) in activeFriendListeners {
            listener.remove()
        }
        activeFriendListeners.removeAll()
    }

}


