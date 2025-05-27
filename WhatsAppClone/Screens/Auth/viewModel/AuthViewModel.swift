//
//  AuthViewModel.swift
//  WhatsAppClone
//
//  Created by Manthan on 18/05/25.
//

import FirebaseAuth
import FirebaseFirestore
import Combine

@MainActor
final class AuthViewModel: ObservableObject{
    
    static var shared = AuthViewModel()
    
    private init(){
        Task{
            await loadCurrentUser()
        }
    }
    
    enum AuthError: Error {
        case somethingWrong
        case invalidVerification
        case unknown
        case invalidOtp
        case errorFirestore
    }
    
    var verificationID: String?
    var userUid : String = ""
    var userPhone : String = ""
    
    @Published var currentUser : User?
    @Published var firebaseUser : FirebaseAuth.User?
    @Published var userAvatar = UserAvatarsList.arrayAvatars.first
    @Published var isNewUser: Bool = true
    @Published var isNumberVerified : Bool = false
    
    private let auth = Auth.auth()
    
    func loadCurrentUser() async{
        if let user = auth.currentUser{
                await fatchUserDetail(with: user.uid){ userData in
                    switch userData {
                    case .success(let userDetails):
                        self.currentUser = userDetails
                        fatchAvatarsDetails(with: self.currentUser!.userAvatar) { avatar in
                            switch avatar{
                            case .success(let userAvatar):
                                self.userAvatar = userAvatar
                                self.firebaseUser = user
                            case .failure(_):
                                firebaseUser = nil
                                userAvatar = nil
                            }
                        }
                    case .failure(_):
                        firebaseUser = nil
                        userAvatar = nil
                        self.currentUser = nil
                    }
                }
        }
    }
    
    func sendOTP(to phoneNumber: String){
        AppFunctions.showLoader()
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { [weak self] verificationID, error in
            guard let self else {return}
            AppFunctions.hideLoader()
            if let error = error {
                print("Error sending OTP: \(error.localizedDescription)")
                self.isNumberVerified = false
                return
            }
            
            guard let verificationID = verificationID else {
                self.isNumberVerified = false
                return
            }
            
            self.verificationID = verificationID
            self.userPhone = phoneNumber
            self.isNumberVerified = true
        }
    }
    
    
    func verifyOTP(_ code: String) {
        AppFunctions.showLoader()
        guard let verificationID = verificationID else {
            return
        }
        
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID, verificationCode: code)
        
        Auth.auth().signIn(with: credential) { [weak self] authResult, error in
            
            guard let self else {return}
            AppFunctions.hideLoader()
            if let error = error {
                print("OTP verification failed: \(error.localizedDescription)")
                return
            }
            guard let authResult = authResult else {
                return
            }
            
          
            let uid = authResult.user.uid
            print(uid)
            
            Task{
                await self.fatchUserDetail(with: uid) { users in
                    switch users{
                    case .success(let user):
                        self.currentUser = user
                        self.fatchAvatarsDetails(with: user.userAvatar){ avatar in
                            switch avatar{
                            case .success(let avatar):
                                self.userAvatar = avatar
                                self.firebaseUser = authResult.user
                            case .failure(_):
                                self.userAvatar = nil
                                self.firebaseUser = nil
                            }
                        }
                        
                    case .failure(_):
                        Task{
                            await self.userEntryInFireStore(userUid: uid, userName: "", UserBio: ""){ added in
                                if added{
                                    Task{
                                        await self.fatchUserDetail(with: uid) { users in
                                            switch users{
                                            case .success(let user):
                                                self.currentUser = user
                                                self.fatchAvatarsDetails(with: user.userAvatar){ avatar in
                                                    switch avatar{
                                                    case .success(let avatar):
                                                        self.userAvatar = avatar
                                                        self.firebaseUser = authResult.user
                                                    case .failure(let error):
                                                        self.userAvatar = nil
                                                        self.firebaseUser = nil
                                                    }
                                                }
                                            
                                            case .failure(let error):
                                                print(error)
                                                self.firebaseUser = nil
                                                self.currentUser = nil
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func fatchUserDetail(with uid: String, completion: ((Result<User, Error>)) -> Void) async{
        do{
            let document = try await db.collection("User").document(uid).getDocument()
            let user = try document.data(as: User.self)
            completion(.success(user))
        }catch{
            completion(.failure(AuthError.somethingWrong))
            currentUser = nil
        }
    }
    
    func fatchAvatarsDetails(with avatarName:String, completion: (Result<UserAvatarsList, Error>) -> ()){
        if let avatar = UserAvatarsList.arrayAvatars.first(where: {$0.avatarName == avatarName}){
            completion(.success(avatar))
//            userAvatar = avatar
           // self.firebaseUser = user
        }else{
            completion(.failure(AuthError.unknown))
            userAvatar = nil
            self.firebaseUser = nil
        }
    }
    
    func userEntryInFireStore(userUid : String ,userName : String, UserBio : String, completion : (Bool) -> ()) async {
        AppFunctions.showLoader()
        let user = User(userName: userName, userPhone: userPhone, userBio: UserBio, userAvatar: userAvatar?.avatarName ?? "userAvatar1")
        print(user)
        AppFunctions.hideLoader()
        do {
            try db.collection("User").document(userUid).setData(from: user)
            completion(true)
        } catch {
            completion(false)
        }
    }
    
    func updateEntryInFireStore(userName : String, UserBio : String) async {
        AppFunctions.showLoader()
        let user = User(userName: userName, userPhone: userPhone, userBio: UserBio, userAvatar: userAvatar?.avatarName ?? "userAvatar1")
        
        let updatedData: [String: Any] = [
                "userName": userName,
                "userBio": UserBio,
                "userAvatar": userAvatar?.avatarName ?? ""
            ]
        do {
            try await db.collection("User").document(firebaseUser!.uid).updateData(updatedData)
            AppFunctions.hideLoader()
            
            await fatchUserDetail(with: firebaseUser?.uid ?? "") { userDetails in
                switch userDetails{
                case .success(let userData):
                    fatchAvatarsDetails(with: userData.userAvatar) { userAvatarDetails in
                        switch userAvatarDetails {
                        case .success(let avatar):
                            self.userAvatar = avatar
                            currentUser = userData
                        case .failure(_):
                            self.userAvatar = nil
                            self.currentUser = nil
                            self.firebaseUser = nil
                        }
                    }
                case .failure(_):
                    currentUser = nil
                    firebaseUser = nil
                }
            }
        
        } catch {
            firebaseUser = nil
            currentUser = nil
            AppFunctions.hideLoader()
        }
    }
    
    func signOut() {
        do {
            firebaseUser = nil
            currentUser = nil
            isNumberVerified = false
            try auth.signOut()
        }catch {
           
        }
    }
    
}
