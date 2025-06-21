//
//  HomeScreenView.swift
//  WhatsAppClone
//
//  Created by Manthan on 24/05/25.
//

import SwiftUI

struct HomeScreenView: View {
    
    @State var selectedValue : String = "Explore"
    @StateObject var homeVM = HomeViewModel.shared
    @EnvironmentObject var authVM : AuthViewModel

    @State var isChatSelected : Bool = true
  
    var body: some View {
        NavigationStack{
            VStack{
                customNavBarView
                ZStack{
                    if isChatSelected{
                        if selectedValue == homeVM.segmentArrey.first {
                            ExploreListView()
                                .environmentObject(homeVM)
                                .padding(.top, 50)
                        }else{
                            FriendListView()
                                .environmentObject(homeVM)
                                .padding(.top, 50)
                        }
                    }else{
                        SettingView()
                            .environmentObject(authVM)
                            .padding(.top, 20)
                    }
                    VStack{
                        if isChatSelected{
                            customSegment(with: homeVM.segmentArrey, selected: selectedValue)
                                .padding(.horizontal, 10)
                        }
                        
                        Spacer()
                        
                        customTabBar
                            .padding()
                    }
                }
                
            }
            .background(AppFunctions.avatarGradient(from: authVM.userAvatar!).ignoresSafeArea().opacity(0.4))
            .onAppear(){
                homeVM.fetchUsers()
            }
        }
    }
    

    
    var customNavBarView: some View{
        ZStack{
            Text(isChatSelected ? "Chats" : "Setting")
                .font(.system(size: 20, weight: .medium))
            HStack{
                Spacer()
                Spacer()
            }
        }
        .frame(height: 30)
       // .background(Color(.systemGray6))
    }
    
    private func customSegment(with tabs:[String], selected: String) -> some View{
        GeometryReader{ geometry in
            
            let geometryWidth = geometry.size.width / CGFloat(tabs.count)
            
            ZStack(alignment: .leading){
                HStack{
                    Rectangle()
                        .background(Color.black)
                        .frame(width: geometryWidth - 14)
                        .cornerRadius(geometry.size.height / 2)
                        .offset(x: CGFloat(tabs.firstIndex(of: selected) ?? 0) * geometryWidth)
                        .animation(.easeInOut(duration: 0.4), value: selected)
                }
                .padding([.leading, .top, .bottom], 7)
                
                HStack{
                    ForEach(tabs, id: \.self) { segment in
                        Button {
                            selectedValue = segment
                        } label: {
                            HStack{
                                Spacer()
                                Text(segment)
                                    .multilineTextAlignment(.center)
                                    .font(.system(size: 20, weight: .medium))
                                    .foregroundStyle(selectedValue == segment ? Color.white : Color.black)
                                Spacer()
                            }
                        }
                        .scaleEffect(1)
                    }
                }
            }
            .frame(height: 50)
            .background(Color(uiColor: .systemGray6).opacity(0.5))
            .cornerRadius(geometry.size.height / 2)
        }
    }
    
    var customTabBar: some View {
        HStack(spacing: 0) {
            Button {
                isChatSelected = true
            } label: {
                Image(isChatSelected ? "chat_fill_icn" : "chat_unfill_icn")
                    .resizable()
                    .aspectRatio(1, contentMode: .fit)
                    .frame(height: 35)
    
            }
            .frame(maxWidth: .infinity)

            Button {
                isChatSelected = false
            } label: {
                Image(isChatSelected ? "setting_unfill_icn" : "setting_fill_icn" )
                    .resizable()
                    .aspectRatio(1, contentMode: .fit)
                    .frame(height: 35)
                
            }
            .frame(maxWidth: .infinity)
        }
        .frame(height: 60)
        .background(Color.white.opacity(0.4))
        .cornerRadius(30)
        .padding(.horizontal)
        .padding(.bottom) // padding for safe area
    }

}

#Preview {
    HomeScreenView()
    
}
