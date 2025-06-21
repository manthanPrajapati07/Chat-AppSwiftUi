//
//  SettingView.swift
//  WhatsAppClone
//
//  Created by Manthan on 01/06/25.
//

import SwiftUI

struct SettingView: View {
    @EnvironmentObject var authVM : AuthViewModel
    @EnvironmentObject var homeVM : HomeViewModel
    @State private var showAvatarSheet = false
    @State private var showSignOutAlert = false
    @State private var showDeleteUserAlert = false
    var body: some View {
        VStack{
            profileInfoView
            HStack{
                Button {
                    showSignOutAlert = true
                } label: {
                    Text("Sign Out")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundStyle(Color.black)
                        .padding(.leading)
                }
                Spacer()
                
                    .alert(isPresented: $showSignOutAlert) {
                        Alert(
                            title: Text("Sign Out ?"),
                            message: Text("Do you want to sign out ?"),
                            primaryButton: .default(Text("Yes")) {
                                authVM.signOut()
                            },
                            secondaryButton: .cancel()
                        )
                    }
            }
            .frame(height: 50)
            .background(Color.white.opacity(0.5))
            .cornerRadius(10)
            
            
            HStack{
                Button {
                    showDeleteUserAlert = true
                } label: {
                    Text("Delete Account")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundStyle(Color.black)
                        .padding(.leading)
                }
                Spacer()
                
                    .alert(isPresented: $showDeleteUserAlert) {
                        Alert(
                            title: Text("Delete Account ?"),
                            message: Text("Do you want to delete account ?"),
                            primaryButton: .default(Text("Yes")) {
                                authVM.deleteUser()
                            },
                            secondaryButton: .cancel()
                        )
                    }
            }
            .frame(height: 50)
            .background(Color.white.opacity(0.5))
            .cornerRadius(10)
            
            Spacer()
            
                .sheet(isPresented: $showAvatarSheet) {
                    AvatarSheetView(selectedAvatar: $authVM.userAvatar)
                        .presentationDetents([.medium])
                        .presentationDragIndicator(.visible)
                }
            
            
        }
        .onChange(of: authVM.userAvatar) { oldValue, newValue in
            if newValue != oldValue{
                print(newValue)
                Task{
                    await homeVM.updateMyProfileAvatar(newAvatar: newValue)
                }
            }
        }
        
    }
    
    
    
    var profileInfoView : some View {
        VStack{
            Button {
                showAvatarSheet = true
            } label: {
                HStack{
                    Spacer()
                    ZStack{
                        Image(authVM.userAvatar!.avatarName)
                            .resizable()
                            .aspectRatio(1, contentMode: .fit)
                            .frame(height: 80)
                        
                        HStack{
                            Spacer()
                            VStack{
                                Spacer()
                                Image("icn_edit")
                                    .resizable()
                                    .aspectRatio(1, contentMode: .fit)
                                    .frame(height: 25)
                            }
                        }
                        .frame(width: 80, height: 80)
            
                    }
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top, 10)
                
            }

            HStack{
                Spacer()
                Button {
    
                } label: {
                    Text(authVM.currentUser?.userName ?? "user")
                        .font(.system(size: 20 ,weight: .medium))
                        .multilineTextAlignment(.center)
                        .foregroundStyle(Color.black)
                }
                Spacer()
            }
            .padding(.horizontal)
            .padding(.bottom, 10)
        }
        .background(Color.white.opacity(0.5))
        .cornerRadius(20.0)
    }
}

#Preview {
    SettingView()
}
