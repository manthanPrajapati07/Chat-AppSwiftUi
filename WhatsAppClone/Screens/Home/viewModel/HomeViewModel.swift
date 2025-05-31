//
//  HomeViewModel.swift
//  WhatsAppClone
//
//  Created by Manthan on 24/05/25.
//

import Foundation
import SwiftUI
@MainActor
final class HomeViewModel : ObservableObject{
    
    static let shared = HomeViewModel()
    private init(){}
    
    let segmentArrey = ["Explore", "Friends"]
    
    @Published var arrExploreUsers : [AllUserModel] = []
    
//    func fetchExploreUsersList() async {
//        AppFunctions.showLoader()
//        do {
//            AppFunctions.hideLoader()
//            let snapshot = try await db.collection("User").getDocuments()
//            self.arrExploreUsers = try snapshot.documents.map { document in
//                try document.data(as: User.self)
//            }
//            print(self.arrExploreUsers)
//        } catch {
//            AppFunctions.hideLoader()
//            print("Error fetching users: \(error.localizedDescription)")
//        }
//    }
//    
    
    
    func fetchFetchExploreUsersList()  {
        AppFunctions.showLoader()
        let query = db.collection("User")
        query.getDocuments() { (querySnapshot, err) in
            AppFunctions.hideLoader()
                if let err = err {
                    print("Error getting documents: \(err)")
                   
                } else {
                    let results = querySnapshot!.documents.map { (document) -> AllUserModel in
                        if let task = AllUserModel(dictionary: document.data(), id: document.documentID) {
                            return task
                        } else {
                            fatalError("Unable to initialize type \(AllUserModel.self) with dictionary \(document.data())")
                        }
                    }
                    self.arrExploreUsers = results
                    print(self.arrExploreUsers)
        
                }
        }
    }
}


struct AllUserModel : Codable, Hashable{
       var userAvatar: String
       var userBio: String
       var userEmail: String
       var userName: String
       var userPhone: String
}

extension AllUserModel{
    init?(dictionary: [String : Any], id: String) {
        
        guard   let userAvatar = dictionary["userAvatar"] as? String,
                let userBio = dictionary["userBio"] as? String,
                let userEmail = dictionary["userEmail"] as? String,
                let userName = dictionary["userName"] as? String,
                let userPhone = dictionary["userPhone"] as? String
        else { return nil }
        
        self.init(userAvatar: userAvatar, userBio: userBio, userEmail: userEmail, userName: userName, userPhone: userPhone)
    }
}
