//
//  ChatView.swift
//  WhatsAppClone
//
//  Created by Manthan on 07/06/25.
//

import SwiftUI

struct ChatView: View {
    
    @StateObject var chatVM = ChatViewModel.shared
    @EnvironmentObject var homeVM : HomeViewModel
    @StateObject var authVM = AuthViewModel.shared
    @State private var message: String = ""
 
    private var isValidInput : Bool{
         !message.isEmptyOrWhitespace()
    }
    
    var body: some View {
        VStack{
            userListView(image: homeVM.selectedFriend!.friendAvatar, name:homeVM.selectedFriend!.friendName, lastSeen: homeVM.selectedFriend!.isFriendOnline)
            Divider()
            
            ScrollView{
                ForEach(chatVM.arrMessages, id: \.MessageId){message in
                    
                    if message.MessageSenderId == AppFunctions.getCurrentUserId(){
                        messageView(message: message.MessageText, aligment: .trailing, color: .blue, isSender: true)
                            .padding(.vertical, 5)
                            .padding(.horizontal, 10)
                    }else{
                        messageView(message: message.MessageText, aligment: .leading, color: .gray, isSender: false)
                            .padding(.vertical, 5)
                            .padding(.horizontal, 10)
                    }
                }
            }
            .background(Color.clear)
            
            bottomTextView()
         
        }.onAppear {
            chatVM.listenToMessages(with: homeVM.selectedFriend!.friendId)
        }
        .background(AppFunctions.avatarGradient(from: authVM.userAvatar!).ignoresSafeArea().opacity(0.4))
    }
    
    
    private func userListView(image: String, name: String, lastSeen: Bool)-> some View{
        HStack{
            Image(image)
                .resizable()
                .aspectRatio(1, contentMode: .fit)
                .frame(height: 50)
                .padding(.leading, 10)
            
            VStack(spacing: 0.0){
                HStack{
                    Text(name)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundStyle(Color.black)
                    Spacer()
                }
                HStack{
                    Text(lastSeen ? "online":"ofline")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(Color.gray)
                        .italic()
                    Spacer()
                }
                
            }
            .padding(.horizontal, 3)
            
            Spacer()
        }
        .frame(height: 50)
    }
    
    
    private func messageView(message: String, aligment : Alignment, color: Color, isSender: Bool) -> some View{
        HStack{
            HStack{
                Text(message)
                    .font(.system(size: 22, weight: .medium))
                    .layoutPriority(0)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 20)
            }
            .background(color)
            .cornerRadius(20)
            .padding(isSender ? .leading : .trailing)
        
        }
        .frame(maxWidth: .infinity, alignment: aligment)
    }
    
    private func bottomTextView() -> some View{
        HStack{
            HStack{
                TextField("Message...", text: $message, axis: .vertical)
                    .font(.system(size: 20, weight: .medium))
                    .padding()
            }
            .frame(minHeight: 50)
            .background(Color.white)
            .cornerRadius(25)
            .padding(.leading)
            .autocapitalization(.none)
            
            Button {
                if isValidInput{
                    Task{
                        do{
                            try await chatVM.sendMessage(to: homeVM.selectedFriend!.friendId, text: message)
                            message = ""
                            UIApplication.shared.endEditing()
                        } catch{
                            print(error.localizedDescription)
                        }
                    }
                }
            } label: {
                HStack{
                    Image("sendButton_icn")
                        .resizable()
                        .aspectRatio(1, contentMode: .fit)
                        .frame(height: 25)
                }
            }
            .frame(width: 50, height: 50)
            .background(Color.green).opacity(0.8)
            .cornerRadius(25)
            .padding([ .trailing])
            .padding(.leading, 5)

        }
        .frame(maxHeight: 70 , alignment: .top)
    }
}

#Preview {
    ChatView()
}
