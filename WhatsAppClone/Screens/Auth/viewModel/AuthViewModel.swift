//
//  AuthViewModel.swift
//  WhatsAppClone
//
//  Created by Manthan on 18/05/25.
//

import FirebaseAuth
import FirebaseFirestore
import Combine

final class AuthViewModel{
    
    static var shared = AuthViewModel()
    
    private init(){}
    
    enum AuthError: Error {
        case somethingWrong
        case invalidVerification
        case unknown
        case invalidOtp
        case errorFirestore
    }
    
    enum AuthState {
           case inActive
           case newUser
           case existingUser
           case error(AuthError)
       }
    
    enum numberVerifiedState {
           case inActive
           case numberVerified
           case error(AuthError)
       }

    var verificationID: String?
    let db = Firestore.firestore()
    var userUid : String = ""
    
    @Published var authState: AuthState = .inActive
    @Published var numberVerifiedState : numberVerifiedState = .inActive
    
    func sendOTP(to phoneNumber: String){
            PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { [weak self] verificationID, error in
                guard let self else {return}
                if let error = error {
                    print("Error sending OTP: \(error.localizedDescription)")
                    self.numberVerifiedState = .error(.somethingWrong)
                    return
                }

                guard let verificationID = verificationID else {
                    self.numberVerifiedState = .error(.invalidVerification)
                    return
                }

                self.verificationID = verificationID
                self.numberVerifiedState = .numberVerified
            }
        }
    
    
    func verifyOTP(_ code: String) {
            guard let verificationID = verificationID else {
                authState = .error(.invalidVerification)
                return
            }

            let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID, verificationCode: code)

            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    print("OTP verification failed: \(error.localizedDescription)")
                    self.authState = .error(.invalidOtp)
                    return
                }

                guard let authResult = authResult else {
                    self.authState = .error(.unknown)
                    return
                }
                
                let uid = authResult.user.uid
                self.userUid = uid
                
                self.checkUserExist(with: uid) { exist in
                    if exist{
                        self.authState = .existingUser
                    }else{
                        self.authState = .newUser
                    }
                }
                  
            }
        }
    
    func checkUserExist(with uid: String, completion : @escaping (Bool)-> Void){
        db.collection("User").document(uid).getDocument { document, error in
            if let document = document, document.exists{
                completion(true)
            }else{
                completion(false)
            }
        }
    }
    
    func userEntryInFireStore(userPhone :String, userName : String, userAvatar : String, UserBio : String, completion: @escaping (Result<String, Error>) -> Void) async {
        
       let user = User(id: userUid, userName: userName, userPhone: userPhone, userBio: UserBio, userAvatar: userAvatar)
        
        do {
            try await db.collection("User").document(user.id).setData(user.dictionary)
            completion(.success("success"))
        } catch {
            completion(.failure(AuthError.errorFirestore))
        }
    }
    
}
