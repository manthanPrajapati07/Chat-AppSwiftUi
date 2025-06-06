//
//  FriendListView.swift
//  WhatsAppClone
//
//  Created by Manthan on 06/06/25.
//

import SwiftUI

struct FriendListView: View {
    @EnvironmentObject var homeVM : HomeViewModel
    
    var body: some View {
        ScrollView{
            VStack{
                ForEach(homeVM.arrUserFriend, id: \.friendId) { friendList in
                    VStack{
                        Spacer()
                        userListView(image: friendList.friendAvatar, name: friendList.friendName, massage: friendList.lastMassage)
                        Spacer()
                        Divider()
                            .padding(.leading, 60)
                    }
                    .frame(height: 70)
                }
            }
            .padding(.top, 20)
            .padding(.bottom, 100)
          
        }
    }
    
    
    private func userListView(image: String, name: String, massage: String)-> some View{
        HStack{
            Image(image)
                .resizable()
                .aspectRatio(1, contentMode: .fit)
                .frame(height: 50)
                .padding(.leading, 10)
            
            VStack(spacing: 5.0){
                HStack{
                    Text(name)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundStyle(Color.black)
                    Spacer()
                }
                HStack{
                    Text(massage)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(Color.gray)
                        .italic()
                    Spacer()
                }
                
            }
            .padding(.horizontal, 5)
            
            
            Spacer()
        }
        .frame(height: 50)
    }
}

#Preview {
    FriendListView()
}
