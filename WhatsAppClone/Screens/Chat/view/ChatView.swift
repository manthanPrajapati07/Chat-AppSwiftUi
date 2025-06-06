//
//  ChatView.swift
//  WhatsAppClone
//
//  Created by Manthan on 07/06/25.
//

import SwiftUI

struct ChatView: View {
    
    @StateObject var chatVM = ChatViewModel.shared
   // @EnvironmentObject var homeVM : HomeViewModel
    
    var body: some View {
        VStack{
            userListView(image: "userAvatar1", name: "Ankita", lastSeen: "online")
            Divider()
            
            ScrollView{
                ForEach(0..<10){message in
                    if message % 2 == 0{
                        messageView(message: "hello", aligment: .leading, color: .gray, isSender: false)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 10)
                    }else{
                        messageView(message: "hello manthan how are you? are you okeyy", aligment: .trailing, color: .blue, isSender: true)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 10)
                    }
                }
            }
            Spacer()
        }
    }
    
    
    private func userListView(image: String, name: String, lastSeen: String)-> some View{
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
                    Text(lastSeen)
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
                    .font(.system(size: 24, weight: .medium))
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
}

#Preview {
    ChatView()
}
