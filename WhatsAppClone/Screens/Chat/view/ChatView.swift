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
    @State private var shouldScrollToBottom: Bool = false
    @State private var didInitialScroll: Bool = false
    @State var isTypingStart : Bool = false
    @State private var typingTimer: Timer? = nil

    let TYPING_TIMEOUT: TimeInterval = 2.0
    
    private var isValidInput : Bool{
         !message.isEmptyOrWhitespace()
    }
    
    var body: some View {
        VStack{
            if chatVM.userDetailFound{
                VStack{
                    userListView(image: chatVM.observedFriend!.userAvatar, name:chatVM.observedFriend!.userName, lastSeen: chatVM.observedFriend!.isUserOnline)
                    
                    Divider()
                    ScrollViewReader { scrollViewProxy in
                        ScrollView {
                            LazyVStack(spacing: 0) {
                                let groupedMessages = Dictionary(grouping: chatVM.arrMessages) { message in
                                    AppFunctions.getMessageTimeSheet(from: message.MessageTimestamp).date
                                }
                                let sortedDates = groupedMessages.keys.sorted { date1, date2 in
                                    guard
                                        let t1 = groupedMessages[date1]?.first?.MessageTimestamp,
                                        let t2 = groupedMessages[date2]?.first?.MessageTimestamp
                                    else { return false }
                                    return t1 < t2
                                }
                                
                                ForEach(sortedDates, id: \.self) { date in
                                    // Date header
                                    if let anyMessage = groupedMessages[date]?.first {
                                        chatRowView(timeStamp: anyMessage.MessageTimestamp)
                                            .frame(maxWidth: .infinity)
                                            .padding(.vertical, 5)
                                    }
                                    
                                    ForEach(groupedMessages[date]!, id: \.MessageId) { message in
                                        Group {
                                            if message.MessageSenderId == AppFunctions.getCurrentUserId() {
                                                messageView(message: message, aligment: .trailing, color: .blue, isSender: true, isMessageRead: message.MessageIsRead)
                                            } else {
                                                messageView(message: message, aligment: .leading, color: .gray, isSender: false, isMessageRead: message.MessageIsRead)
                                                    .onAppear{
                                                        Task{
                                                          await chatVM.setMesssageRead(to: homeVM.selectedFriend!.friendId, messageId: message.MessageId)
                                                        }
                                                    }
                                            }
                                        }
                                        .padding(.vertical, 5)
                                        .padding(.horizontal, 10)
                                    }
                                }
                            }
                        }
                        .background(Color.clear)
                        .onAppear {
                            // 👇 Scroll only on first appear
                            if !didInitialScroll {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                    if let lastId = chatVM.arrMessages.last?.MessageId {
                                        scrollViewProxy.scrollTo(lastId, anchor: .bottom)
                                        didInitialScroll = true
                                    }
                                }
                            }
                        }
                        .onChange(of: shouldScrollToBottom) { shouldScroll in
                            if shouldScroll {
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    if let lastMessageId = chatVM.arrMessages.last?.MessageId {
                                        scrollViewProxy.scrollTo(lastMessageId, anchor: .bottom)
                                    }
                                }
                                shouldScrollToBottom = false
                            }
                        }
                    }
                    
                    bottomTextView()
                    
                }
            }
            
        }
        .onAppear {
            chatVM.listenToMessages(with: homeVM.selectedFriend!.friendId)
            chatVM.listenToFriendDetailChange(with: homeVM.selectedFriend!.friendId)
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
    
    
    private func messageView(message: MessageModel, aligment : Alignment, color: Color, isSender: Bool, isMessageRead: Bool) -> some View{
        HStack{
            HStack{
                Text(message.MessageText)
                    .font(.system(size: 22, weight: .medium))
                    .layoutPriority(0)
                    .padding(.vertical, 8)
                    .padding(.leading, 20)
                
                HStack(spacing: 5){
                    
                    Text(AppFunctions.getMessageTimeSheet(from: message.MessageTimestamp).time)
                        .font(.system(size: 10, weight: .regular))
                    
                    if isSender{
                        
                        Image(isMessageRead ? "doubleTick" : "SingleTick")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20,height: 20)
                    }
                }
                .padding(.trailing)
               
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
                    .onChange(of: message) { newValue in
                                    typingTimer?.invalidate()
                                    typingTimer = nil

                                    if !isTypingStart {
                                        isTypingStart = true
                                        Task {
                                            await chatVM.updateTypingStatus(uid: homeVM.selectedFriend!.friendId, isTypingStatus: true)
                                        }
                                    }
                                    if newValue.isEmptyOrWhitespace() {
                                        typingTimer?.invalidate()
                                        typingTimer = nil
                                        if isTypingStart {
                                            Task {
                                                await chatVM.updateTypingStatus(uid: homeVM.selectedFriend!.friendId, isTypingStatus: false)
                                            }
                                            isTypingStart = false
                                        }
                                    } else {
                                        typingTimer = Timer.scheduledTimer(withTimeInterval: TYPING_TIMEOUT, repeats: false) { _ in
                                            Task {
                                                await chatVM.updateTypingStatus(uid: homeVM.selectedFriend!.friendId, isTypingStatus: false)
                                            }
                                            isTypingStart = false
                                        }
                                    }
                                }
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
                            DispatchQueue.main.async {
                                shouldScrollToBottom = true
                            }
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
    
    private func chatRowView(timeStamp: Int) -> some View {
        let date = AppFunctions.getMessageTimeSheet(from: timeStamp).date
        let day = AppFunctions.getMessageTimeSheet(from: timeStamp).day
        let today = AppFunctions.getTodaysDate() == date
        return HStack {
            Spacer()
            Text(today ? "Today":"\(date) • \(day)")
                .font(.caption)
                .foregroundColor(.gray)
                .padding(6)
                .background(Color.white.opacity(0.8))
                .cornerRadius(10)
            Spacer()
        }
    }

}

#Preview {
    ChatView()
}
