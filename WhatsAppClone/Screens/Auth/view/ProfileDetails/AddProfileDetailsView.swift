//
//  AddProfileDetailsView.swift
//  WhatsAppClone
//
//  Created by Manthan on 19/05/25.
//

import SwiftUI

struct AddProfileDetailsView: View {
    
    @State var userName : String = ""
    @State var userBio : String = ""
    @Binding var userPhoneNumber : String
    
    @State private var selectedAvatar : UserAvatarsList = UserAvatarsList.arrayAvatars.first!
    
    @State private var showAvatarSheet = false

    
    var isValid: Bool {
        !userName.isEmptyOrWhitespace()
    }
        
    
    var body: some View {
        NavigationView{
            VStack{
                CustomNavigationBar
                ScrollView{
                    VStack{
                       // CustomNavigationBar
                        profileInfoView
                        phoneNumberView
                        BioView
                    }
                    Spacer()
                }
                .sheet(isPresented: $showAvatarSheet) {
                    AvatarSheetView(selectedAvatar: $selectedAvatar)
                        .presentationDetents([.medium])
                        .presentationDragIndicator(.visible)
                }
            }
            .background(AppFunctions.avatarGradient(from: selectedAvatar).ignoresSafeArea().opacity(0.4))
        }
        .navigationBarBackButtonHidden()
        
    }
    
    var CustomNavigationBar: some View {
        ZStack {
            Text("Profile Details")
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(Color(selectedAvatar.primaryFontColor))
            
            HStack{
                Spacer()
                Button {
                    
                } label: {
                    Text("Done")
                        .font(.system(size: 20, weight: .regular))
                        .foregroundStyle(isValid ? Color.blue : Color.gray)
                }
                .padding(.trailing)
            }
        }
        .frame(height: 50)
  //      .background(Color(.systemGray6))
    }
    
    
    var profileInfoView : some View {
        VStack{
            HStack{
                Image(selectedAvatar.avatarName)
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
                Text(userPhoneNumber)
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
    AddProfileDetailsView(userPhoneNumber: .constant("+91 7201035861"))
}
