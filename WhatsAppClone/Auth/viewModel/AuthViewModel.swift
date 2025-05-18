//
//  AuthViewModel.swift
//  WhatsAppClone
//
//  Created by Manthan on 18/05/25.
//

import FirebaseAuth

final class AuthViewModel{
    
    static var shared = AuthViewModel()
    
    private init(){}
    
    enum AuthError: Error {
        case somethingWrong
        case invalidVerification
        case unknown
        case invalidOtp
    }

    var verificationID: String?
    
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
                completion(.failure(.invalidVerification))
                return
            }

            let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID, verificationCode: code)

            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    print("OTP verification failed: \(error.localizedDescription)")
                    completion(.failure(.invalidOtp))
                    return
                }

                guard let authResult = authResult else {
                    completion(.failure(.unknown))
                    return
                }

                completion(.success(authResult))
            }
        }
    
}
