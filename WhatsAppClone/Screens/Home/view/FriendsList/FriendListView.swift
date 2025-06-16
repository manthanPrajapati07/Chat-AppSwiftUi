//
//  FriendListView.swift
//  WhatsAppClone
//
//  Created by Manthan on 06/06/25.
//

import SwiftUI

struct FriendListView: View {
    @EnvironmentObject var homeVM : HomeViewModel
    @State private var navigateToChat : Bool = false
    var body: some View {
        ScrollView{
            VStack{
                ForEach(homeVM.arrUserFriend, id: \.friendId) { friendList in
                    VStack{
                        Spacer()
                        userListView(image: friendList.friendAvatar, name: friendList.friendName, massage: friendList.lastMassage ?? nil)
                        Spacer()
                        Divider()
                            .padding(.leading, 60)
                    }
                    .onTapGesture {
                        homeVM.selectedFriend = friendList
                        navigateToChat = true
                    }
                    .frame(height: 70)
                }
                
                NavigationLink(
                              destination: ChatView()
                                .environmentObject(homeVM),
                              isActive: $navigateToChat,
                              label: {
                                  EmptyView()
                              }
                          )
                          .hidden()
            }
            .padding(.top, 20)
            .padding(.bottom, 100)
          
        }
    }
    
    
    private func userListView(image: String, name: String, massage: MessageModel?)-> some View{
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
                HStack(spacing: 5){
                    if let messageFound = massage{
                        let isSender = messageFound.MessageSenderId == AppFunctions.getCurrentUserId()
                        let isMessageRead = messageFound.MessageIsRead
                        if isSender{
                            Image(isMessageRead ? "doubleTick" : "SingleTick")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20,height: 20)
                        }
                    }
                    
                    Text(massage?.MessageText ?? "Start chat with \(name)")
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
