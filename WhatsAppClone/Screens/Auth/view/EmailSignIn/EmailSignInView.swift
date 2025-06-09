//
//  EmailSignInView.swift
//  WhatsAppClone
//
//  Created by Manthan on 31/05/25.
//

import SwiftUI

struct EmailSignInView: View {
    
    @State var email : String = ""
    @State var password: String = ""
    
    @EnvironmentObject var authVM : AuthViewModel
    
    var isValid : Bool{
        email.isValidGmail() && !password.isEmptyOrWhitespace() && password.count >= 6
    }
    
    var body: some View {
        NavigationView{
            VStack{
                customNavBar
                
                txtEmailView
                    .padding(.top, 40)
                
                txtPasswordView
                    .padding(.top, 20)
                
                Text("password must be 6 digits long")
                    .font(.system(size: 14, weight: .regular))
                    .padding(.top, 50)
                    .foregroundStyle(.gray)
                
                Spacer()
            }
            .navigationBarBackButtonHidden()
        }
        
    }
    
    
    var customNavBar: some View{
        ZStack{
            Text("Email")
                .font(.system(size: 20, weight: .medium))
            
            HStack{
                Spacer()
                Button {
                    if isValid{
                        Task{  await authVM.emailSignUp(email: email, password: password)
                        }
                    }
                } label: {
                    Text("Done")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundStyle(isValid ? Color .blue : Color.gray)
                }
                .padding(.trailing)

            }
        }
        .frame(height: 50)
        .background(Color(.systemGray6))
    }
    
    
    var txtEmailView : some View{
        VStack{
            HStack{
                Text("Email Address")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundStyle(Color.gray)
                    .padding(.horizontal)
        
                Spacer()
            }
            
            HStack{
              TextField("\("manthan123@gmail.com")", text: $email)
                    .font(.system(size: 22, weight: .medium))
                    .foregroundStyle(Color.black)
                    .padding(.horizontal)
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)

                
                Spacer()
            }
            .frame(height: 60)
            .background(Color(.systemGray6))
            .cornerRadius(10)
        }
    }
    
    
    var txtPasswordView : some View{
        VStack{
            HStack{
                Text("Password")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundStyle(Color.gray)
                    .padding(.horizontal)
        
                Spacer()
            }
            
            HStack{
              SecureField("Password", text: $password)
                    .font(.system(size: 22, weight: .medium))
                    .foregroundStyle(Color.black)
                    .padding(.horizontal)
        
                
                Spacer()
            }
            .frame(height: 60)
            .background(Color(.systemGray6))
            .cornerRadius(10)
        }
    }
}

#Preview {
    EmailSignInView()
}
