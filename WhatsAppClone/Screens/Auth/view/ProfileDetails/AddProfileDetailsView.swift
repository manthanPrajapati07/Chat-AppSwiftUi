//
//  AddProfileDetailsView.swift
//  WhatsAppClone
//
//  Created by Manthan on 19/05/25.
//

import SwiftUI

struct AddProfileDetailsView: View {
    
//    @Binding var userPhoneNumber : String
    @State var userName : String = ""
    @State var userBio : String = ""
    @State private var showAvatarSheet = false
    @EnvironmentObject var authVM : AuthViewModel
    
    var isValid: Bool {
        !userName.isEmptyOrWhitespace()
    }
    
   // @State private var navigateToHome : Bool = false
        
    
    var body: some View {
        NavigationView{
                VStack{
                    CustomNavigationBar
                    ScrollView{
                        VStack{
                            profileInfoView
                            phoneNumberView
                            BioView
                        }
                        Spacer()
                    }
                    .sheet(isPresented: $showAvatarSheet) {
                        AvatarSheetView(selectedAvatar: $authVM.userAvatar)
                            .presentationDetents([.medium])
                            .presentationDragIndicator(.visible)
                    }
                    
//                    NavigationLink(
//                        destination: HomeScreenView(),
//                        isActive: $navigateToHome
//                    ) {
//                        EmptyView()
//                    }
//                    .environmentObject(authVM)
                    

                }
                .background(AppFunctions.avatarGradient(from: authVM.userAvatar!).ignoresSafeArea().opacity(0.4))
//                .onChange(of: authVM.currentUser!) { oldValue, newValue in
//                    if newValue.userName != oldValue.userName{
//                        navigateToHome = true
//                    }
//                }
        
        }
        .navigationBarBackButtonHidden()
    }
    
    var CustomNavigationBar: some View {
        ZStack {
            Text("Profile Details")
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(Color(authVM.userAvatar!.primaryFontColor))
            
            HStack{
                Spacer()
                Button {
                    if isValid{
                        Task{
                           await authVM.updateEntryInFireStore(userName: userName, UserBio: userBio)
                        }
                    }
                } label: {
                    Text("Done")
                        .font(.system(size: 20, weight: .regular))
                        .foregroundStyle(isValid ? Color.blue : Color.gray)
                }
                .padding(.trailing)
            }
        }
        .frame(height: 50)
    }
    
    
    var profileInfoView : some View {
        VStack{
            HStack{
                Image(authVM.userAvatar!.avatarName)
                    .resizable()
                    .aspectRatio(1, contentMode: .fit)
                    .frame(height: 80)
                
                Text("Enter your name and add an optional profile avatar")
                    .font(.system(size: 18 ,weight: .regular))
                    .foregroundStyle(Color.gray)
                    .frame(height: 80)
                    .padding(.leading)
                
                Spacer()
                
            }
            .padding(.horizontal)
            .padding(.top, 30)
            
            HStack{
                Button {
                    showAvatarSheet = true
                } label: {
                    Text("Add")
                        .font(.system(size: 20 ,weight: .medium))
                        .multilineTextAlignment(.center)
                        .foregroundStyle(Color.blue)
                        .frame(width: 80)
                }
                Spacer()
            }
            .padding(.horizontal)
            
            VStack{
                Divider()
                TextField("Enter your name", text: $userName)
                    .frame(height: 40)
                    .font(.system(size: 20, weight: .medium))
                Divider()
            }
            .padding()
        }
        .background(Color.white.opacity(0.5))
        .cornerRadius(20.0)
    }
    
    
    var phoneNumberView : some View{
        VStack{
            HStack{
                Text("PHONE NUMBER")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundStyle(Color.gray)
                Spacer()
            }
            .padding(.horizontal)
            
            HStack{
                Text(authVM.currentUser?.userPhone ?? "")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundStyle(Color.black)
                    .padding(.horizontal)
                
                Spacer()
            }
            .frame(height: 50)
            .background(Color.white.opacity(0.5))
            .cornerRadius(10.0)
        }
        .padding(.vertical)
    }
    
    var BioView : some View{
        VStack{
            HStack{
                Text("BIO")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundStyle(Color.gray)
                Spacer()
            }
            .padding(.horizontal)
            
            HStack{
                TextField("Enter Bio", text: $userBio)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundStyle(Color.black)
                    .padding(.horizontal)
        
                Spacer()
            }
            .frame(height: 50)
            .background(Color.white.opacity(0.5))
            .cornerRadius(10.0)
        }
    }
}

#Preview {
    AddProfileDetailsView()
}
