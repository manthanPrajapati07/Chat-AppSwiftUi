//
//  HomeScreenView.swift
//  WhatsAppClone
//
//  Created by Manthan on 24/05/25.
//

import SwiftUI

struct HomeScreenView: View {
    
    @State var homeVM = HomeViewModel.shared
    @State var selectedValue : String = "Explore"
    
    @StateObject var authVM = AuthViewModel.shared

    
    var body: some View {
        NavigationStack{
            VStack{
                customNavBarView
                
                Text(authVM.currentUser?.userName ?? "hello")
                Button {
                    authVM.signOut()
                } label: {
                    Text("Sign Out")
                }

                customSegment(with: homeVM.segmentArrey, selected: selectedValue)
                    .padding(.horizontal, 10)
                
                Spacer()
                
                customTabBar
                    .padding()
                   
            }
            .background(AppFunctions.avatarGradient(from: authVM.userAvatar!).ignoresSafeArea().opacity(0.4))
        }
    }
    
    var customNavBarView: some View{
        ZStack{
            Text("Chats")
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
    
    var customTabBar : some View{
        GeometryReader{ geometry in
            HStack(spacing: 0.0){
                Button {
                    
                } label: {
                    Image("chat_unfill_icn")
                        .resizable()
                        .aspectRatio(1, contentMode: .fit)
                        .frame(height: 35)
                }
                .frame(width: geometry.size.width * 0.5)
                
//                Spacer()
                Button {
                    
                } label: {
                    Image("setting_unfill_icn")
                        .resizable()
                        .aspectRatio(1, contentMode: .fit)
                        .frame(height: 35)
                }
                .frame(width: geometry.size.width * 0.5)
                
            }
            .frame(height: 50)
            .background(Color.white.opacity(0.4))
            .cornerRadius(geometry.size.height/2)
            
        }
        
    }
    
}

#Preview {
    HomeScreenView()
    
}
