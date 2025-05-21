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
           case newUser
           case existingUser
           case error(AuthError)
       }

    var verificationID: String?
    let db = Firestore.firestore()
    
    @Published var authState: AuthState = .newUser
    
    func sendOTP(to phoneNumber: String, completion: @escaping (Result<Void, AuthError>) -> Void) {
            PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { [weak self] verificationID, error in
                if let error = error {
                    print("Error sending OTP: \(error.localizedDescription)")
                    completion(.failure(.somethingWrong))
                    return
                }

                guard let verificationID = verificationID else {
                    completion(.failure(.invalidVerification))
                    return
                }

                self?.verificationID = verificationID
                completion(.success(()))
            }
        }
    
    
    func verifyOTP(_ code: String, completion: @escaping (Result<AuthDataResult, AuthError>) -> Void) {
            guard let verificationID = verificationID else {
                authState = .error(.invalidVerification)
                completion(.failure(.invalidVerification))
                return
            }

            let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID, verificationCode: code)

            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    print("OTP verification failed: \(error.localizedDescription)")
                    completion(.failure(.invalidOtp))
                    self.authState = .error(.invalidOtp)
                    return
                }

                guard let authResult = authResult else {
                    guard let uid = authResult?.user.uid else {
                        self.authState = .error(.unknown)
                        return
                    }
                    completion(.failure(.unknown))
                    return
                }

                completion(.success(authResult))
            }
        }
    
    func userEntryInFireStore(user: User, completion: @escaping (Result<String, AuthError>) -> Void) async {
        do {
            try await db.collection("User").document(user.id).setData(user.dictionary)
            completion(.success("success"))
        } catch {
            completion(.failure(.errorFirestore))
        }
    }
    
}
