//
//  AvatarSheetView.swift
//  WhatsAppClone
//
//  Created by Manthan on 21/05/25.
//

import SwiftUI

struct AvatarSheetView: View {
    
    var ArrAvatars = UserAvatarsList.arrayAvatars
    let columns = Array(repeating: GridItem(.flexible(), spacing: ipad ? 50 : 20), count: ipad ? 4 : 3)
    
    @Environment(\.dismiss) private var dismiss

    @Binding var selectedAvatar : UserAvatarsList?
    
    var body: some View {
        NavigationView{
            ScrollView{
                LazyVGrid(columns: columns, spacing: 20) {
                    
                    ForEach(ArrAvatars) { avatar in
                        Image(avatar.avatarName)
                            .resizable()
                            .aspectRatio(1, contentMode: .fit)
                            .frame(height: ipad ? 200 : 100)
                            .onTapGesture {
                                selectedAvatar = avatar
                                dismiss() 
                            }
                    }
                    
                }
                .padding()
            }
            .navigationTitle("Choose Avatars")
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

#Preview {
    AvatarSheetView(selectedAvatar: .constant(UserAvatarsList(avatarName: "userAvatar1", avatarColor1: "#9A6F9D", avatarColor2: "#DD8AB4", primaryFontColor: .white, buttonColor: .white, secondaryFontColor : .white, primaryThemeColor: .white, secondaryThemeColor: .white)))
}
