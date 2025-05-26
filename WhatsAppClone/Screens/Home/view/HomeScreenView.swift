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
    
    @EnvironmentObject var authVM : AuthViewModel

    
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
            }
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
        .background(Color(.systemGray6))
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
            .background(Color(uiColor: .systemGray6))
            .cornerRadius(geometry.size.height / 2)
        }
    }
    
}

#Preview {
    HomeScreenView()
}
