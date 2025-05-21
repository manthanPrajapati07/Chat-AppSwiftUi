//
//  UserAvatarsModels.swift
//  WhatsAppClone
//
//  Created by Manthan on 21/05/25.
//

import Foundation
import SwiftUICore

struct UserAvatarsList: Identifiable, Equatable{
    let id = UUID()
    let avatarName : String
    let avatarColor1 : String
    let avatarColor2 : String
    let primaryFontColor : Color
    let buttonColor : Color
    let secondaryFontColor : Color
    let primaryThemeColor : Color
    let secondaryThemeColor : Color
    
    static let arrayAvatars : [UserAvatarsList] = {
        [UserAvatarsList(avatarName: "userAvatar1", avatarColor1: "#9A6F9D", avatarColor2: "#DD8AB4", primaryFontColor: .black, buttonColor: .white, secondaryFontColor : .white, primaryThemeColor: .white, secondaryThemeColor: .white),
         UserAvatarsList(avatarName: "userAvatar2", avatarColor1: "#27546B", avatarColor2: "#F7775A", primaryFontColor: .black, buttonColor: .white, secondaryFontColor : .white, primaryThemeColor: .white, secondaryThemeColor: .white),
         UserAvatarsList(avatarName: "userAvatar3", avatarColor1: "#A3D4FF", avatarColor2: "#C28777", primaryFontColor: .black, buttonColor: .white, secondaryFontColor : .white, primaryThemeColor: .white, secondaryThemeColor: .white),
         UserAvatarsList(avatarName: "userAvatar4", avatarColor1: "#09CD67", avatarColor2: "#FFA300", primaryFontColor: .black, buttonColor: .white, secondaryFontColor : .white, primaryThemeColor: .white, secondaryThemeColor: .white),
         UserAvatarsList(avatarName: "userAvatar5", avatarColor1: "#A3D4FF", avatarColor2: "#FE8206", primaryFontColor: .black, buttonColor: .white, secondaryFontColor : .white, primaryThemeColor: .white, secondaryThemeColor: .white),
         UserAvatarsList(avatarName: "userAvatar6", avatarColor1: "#FD6814", avatarColor2: "#616878", primaryFontColor: .black, buttonColor: .white, secondaryFontColor : .white, primaryThemeColor: .white, secondaryThemeColor: .white),
         UserAvatarsList(avatarName: "userAvatar7", avatarColor1: "#73C8EF", avatarColor2: "#FE3C3C", primaryFontColor: .black, buttonColor: .white, secondaryFontColor : .white, primaryThemeColor: .white, secondaryThemeColor: .white),
         UserAvatarsList(avatarName: "userAvatar8", avatarColor1: "#FEE05C", avatarColor2: "#1DA2DD", primaryFontColor: .black, buttonColor: .white, secondaryFontColor : .white, primaryThemeColor: .white, secondaryThemeColor: .white),
         UserAvatarsList(avatarName: "userAvatar9", avatarColor1: "#7FBB1B", avatarColor2: "#617F7F", primaryFontColor: .black, buttonColor: .white, secondaryFontColor : .white, primaryThemeColor: .white, secondaryThemeColor: .white),
         UserAvatarsList(avatarName: "userAvatar10", avatarColor1: "#90DEAA", avatarColor2: "#E6E9EE", primaryFontColor: .black, buttonColor: .white, secondaryFontColor : .white, primaryThemeColor: .white, secondaryThemeColor: .white),
         UserAvatarsList(avatarName: "userAvatar11", avatarColor1: "#FF9000", avatarColor2: "#945230", primaryFontColor: .black, buttonColor: .white, secondaryFontColor : .white, primaryThemeColor: .white, secondaryThemeColor: .white),
         UserAvatarsList(avatarName: "userAvatar12", avatarColor1: "#FE4155", avatarColor2: "#FFF4EE", primaryFontColor: .black, buttonColor: .white, secondaryFontColor : .white, primaryThemeColor: .white, secondaryThemeColor: .white),
         UserAvatarsList(avatarName: "userAvatar13", avatarColor1: "#89CE64", avatarColor2: "#6C5474", primaryFontColor: .black, buttonColor: .white, secondaryFontColor : .white, primaryThemeColor: .white, secondaryThemeColor: .white),
         UserAvatarsList(avatarName: "userAvatar14", avatarColor1: "#FE4155", avatarColor2: "#FFC83A", primaryFontColor: .black, buttonColor: .white, secondaryFontColor : .white, primaryThemeColor: .white, secondaryThemeColor: .white),
         UserAvatarsList(avatarName: "userAvatar15", avatarColor1: "#0CAA5F", avatarColor2: "#E9EDF6", primaryFontColor: .black, buttonColor: .white, secondaryFontColor : .white, primaryThemeColor: .white, secondaryThemeColor: .white),
         UserAvatarsList(avatarName: "userAvatar16", avatarColor1: "#337180", avatarColor2: "#261D18", primaryFontColor: .black, buttonColor: .white, secondaryFontColor : .white, primaryThemeColor: .white, secondaryThemeColor: .white),
         UserAvatarsList(avatarName: "userAvatar17", avatarColor1: "#4AB1F6", avatarColor2: "#70AF46", primaryFontColor: .black, buttonColor: .white, secondaryFontColor : .white, primaryThemeColor: .white, secondaryThemeColor: .white),
         UserAvatarsList(avatarName: "userAvatar18", avatarColor1: "#7E6ED1", avatarColor2: "#FE4155", primaryFontColor: .black, buttonColor: .white, secondaryFontColor : .white, primaryThemeColor: .white, secondaryThemeColor: .white),
         UserAvatarsList(avatarName: "userAvatar19", avatarColor1: "#EE4B68", avatarColor2: "#E9BB06", primaryFontColor: .black, buttonColor: .white, secondaryFontColor : .white, primaryThemeColor: .white, secondaryThemeColor: .white),
         UserAvatarsList(avatarName: "userAvatar20", avatarColor1: "#FFBC37", avatarColor2: "#4A285A", primaryFontColor: .black, buttonColor: .white, secondaryFontColor : .white, primaryThemeColor: .white, secondaryThemeColor: .white)]
    }()
}
