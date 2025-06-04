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
                
                self.arrExploreUsers = results.filter({$0.userId != AppFunctions.getCurrentUserId()})
                print(self.arrExploreUsers)
                
            }
        }
    }
}


