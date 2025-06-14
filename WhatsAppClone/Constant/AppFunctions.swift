//
//  AppFunctions.swift
//  WhatsAppClone
//
//  Created by Manthan on 19/05/25.
//
import UIKit
import NVActivityIndicatorView
import SwiftUICore
import FirebaseAuth

final class AppFunctions{
    
    private init(){}
    
    class func delay(_ delay: TimeInterval, completion : @escaping ()->()){
        DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: completion)
    }
    
    class func showLoader() {
        DispatchQueue.main.async {
            if let window = UIApplication.shared.connectedScenes
                .compactMap({ ($0 as? UIWindowScene)?.keyWindow }).first{
                
                let progressView = UIView(frame: window.bounds)
                progressView.backgroundColor = .black.withAlphaComponent(0.4)
                window.addSubview(progressView)
                progressView.alpha = 0.0
                progressView.tag = 1020
                UIView.animate(withDuration: 0.2) {
                    progressView.alpha = 1.1
                }
                
                let heightWidth :CGFloat = 80
                let x = (UIScreen.main.bounds.width/2)-40
                let y = (UIScreen.main.bounds.height/2)-40
                
                let activityIndicatorView = NVActivityIndicatorView(frame: CGRect(x: x, y: y, width: heightWidth, height: heightWidth), type: .ballRotate, color: .green)
                activityIndicatorView.startAnimating()
                activityIndicatorView.tag = 1020
                progressView.addSubview(activityIndicatorView)
            }
        }
    }
    
    class func hideLoader(){
        DispatchQueue.main.async {
            if let window = UIApplication.shared.connectedScenes
                .compactMap({ ($0 as? UIWindowScene)?.keyWindow }).first{
                if let progressView = window.viewWithTag(1020){
                    if let activityIndicatorView = progressView.viewWithTag(1020) as? NVActivityIndicatorView {
                        activityIndicatorView.stopAnimating()
                    }
                    progressView.removeFromSuperview()
                }
            }
        }
    }
    
    class func ShowToast(massage: String, duration: TimeInterval) {
        DispatchQueue.main.async {
            if let window = UIApplication.shared.connectedScenes
                .compactMap({ ($0 as? UIWindowScene)?.keyWindow }).first {
                
                let view = UIView()
                view.backgroundColor = .black.withAlphaComponent(0.7)
                view.layer.cornerRadius = 10
                view.clipsToBounds = true
                view.alpha = 0

                let width: CGFloat = UIScreen.main.bounds.width - 50
                let height: CGFloat = 30
                let x = (UIScreen.main.bounds.width - width) / 2
                let y = UIScreen.main.bounds.height - 200
                view.frame = CGRect(x: x, y: y, width: width, height: height)
                
                let label = UILabel()
                label.textColor = .white
                label.font = .systemFont(ofSize: 15, weight: .medium)
                label.textAlignment = .center
                label.text = massage
                label.numberOfLines = 0
                label.translatesAutoresizingMaskIntoConstraints = false

                view.addSubview(label)
                NSLayoutConstraint.activate([
                    label.topAnchor.constraint(equalTo: view.topAnchor),
                    label.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                    label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
                    label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10)
                ])
                
                window.addSubview(view)
                
                UIView.animate(withDuration: 0.3) {
                    view.alpha = 1.0
                }

                DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                    UIView.animate(withDuration: 0.3, animations: {
                        view.alpha = 0.0
                    }) { _ in
                        view.removeFromSuperview()
                    }
                }
            }
        }
    }

    
    class func avatarGradient(from avatar: UserAvatarsList) -> LinearGradient {
        return LinearGradient(
            gradient: Gradient(colors: [
                Color(hex: avatar.avatarColor1),
                Color(hex: avatar.avatarColor2)
            ]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    class func getCurrentUserId() -> String{
        if let user = Auth.auth().currentUser{
            return user.uid
        }
        return ""
    }
    
    class func getCurrentTimestamp() -> Int {
        return Int(Date().timeIntervalSince1970 * 1000)
    }
    
    @MainActor
    class func getCurrentUserDetail() -> User? {
        return AuthViewModel.shared.currentUser
    }
    
    class func getMessageTimeSheet(from milliseconds: Int) -> MessageTimeStamp {
           let date = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
           let dateFormatter = DateFormatter()
           
           dateFormatter.dateFormat = "dd MMM yyyy"
           let formattedDate = dateFormatter.string(from: date)
           
           dateFormatter.dateFormat = "EEEE"
           let formattedDay = dateFormatter.string(from: date)
           
           dateFormatter.dateFormat = "hh:mm a"
           let formattedTime = dateFormatter.string(from: date)
           
           return MessageTimeStamp(date: formattedDate, day: formattedDay, time: formattedTime)
       }
    
    class func getTodaysDate() -> String {
        var todaysDate = NSDate()
        var dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        var DateInFormat = dateFormatter.string(from: todaysDate as Date)

        return DateInFormat
    }
    
    @MainActor
      static func setUserOnlineStatus(_ isOnline: Bool) async {
          guard let uid = Auth.auth().currentUser?.uid else { return }
          let ref = db.collection("User").document(uid)
          do {
              try await ref.updateData(["isUserOnline": isOnline])
              print("✅ Updated isUserOnline to \(isOnline)")
          } catch {
              print("❌ Failed to update: \(error.localizedDescription)")
          }
      }
}

