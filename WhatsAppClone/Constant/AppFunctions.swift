//
//  AppFunctions.swift
//  WhatsAppClone
//
//  Created by Manthan on 19/05/25.
//
import UIKit
import NVActivityIndicatorView
import SwiftUICore

final class AppFunctions{
    
    private init(){}
    
    class func delay(_ delay: TimeInterval, completion : @escaping ()->()){
        DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: completion)
    }
    
    class func showLoader() {
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
    
    static func avatarGradient(from avatar: UserAvatarsList) -> LinearGradient {
        return LinearGradient(
            gradient: Gradient(colors: [
                Color(hex: avatar.avatarColor1),
                Color(hex: avatar.avatarColor2)
            ]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}

