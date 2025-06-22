//
//  LoginView.swift
//  WhatsAppClone
//
//  Created by Manthan on 13/05/25.
//

import SwiftUI

struct LoginView: View {
    
    @State var phoneNumber : String = ""
    @State var SelectedCountry = Country(name: "India", code: "+91", validNumberCount: 10)
    @State private var previousCountry: Country? = Country(name: "India", code: "+91", validNumberCount: 10)
    @State private var FullPhoneNumber = ""
    @State private var userModel : User!
    @State private var isNavigateToEmail : Bool = false
    
   // @StateObject var authVM = AuthViewModel.shared
    @EnvironmentObject var authVM : AuthViewModel
        
    var isValidNumber: Bool {
        phoneNumber.count == SelectedCountry.validNumberCount
    }
    
    var body: some View {
        
        NavigationView{
            GeometryReader{ geometry in
                
                VStack(spacing: 0) {
                    CustomNavigationBar
                    
                    Text("Please confirm your country code and enter your phone number")
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: geometry.size.width * 0.8, minHeight: 80)
                        .padding(30)
                    
                    numberAndTxtFeild
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text("use static number +911234567890 if authentication fail")
                        .font(.system(size: 14, weight: .medium))
                        .frame(height: 40)
                        .foregroundStyle(Color.gray)
                        .padding(.top, 100)
                        .padding(.horizontal)
                    
                    
                    emailSignIn
                        .padding(.top, 70)
                    
                    Spacer()
                }
                
                NavigationLink(
                    destination: OtpVerifyView(phoneNumber: $FullPhoneNumber),
                    isActive: $authVM.isNumberVerified
                ) {
                    EmptyView()
                }
                
                NavigationLink(
                    destination: EmailSignInView(),
                    isActive: $isNavigateToEmail
                ) {
                    EmptyView()
                }
                .environmentObject(authVM)
            
            }
        }
        .onChange(of: SelectedCountry) { newValue in
            if newValue.code != previousCountry?.code {
                phoneNumber = ""
            }
            previousCountry = newValue
        }
        .ignoresSafeArea()
    }
    
    
    var CustomNavigationBar: some View {
        ZStack {
            Text("Phone number")
                .font(.system(size: 20, weight: .semibold))
            HStack {
                Spacer()
                Button {
                    if isValidNumber{
                        let wholeNumber = "\(SelectedCountry.code)\(phoneNumber)"
                        FullPhoneNumber = wholeNumber
                        print(wholeNumber)
                        authVM.sendOTP(to: wholeNumber)
                    }
                } label: {
                    Text("Done")
                        .font(.system(size: 20))
                        .foregroundColor(isValidNumber ? .blue : .gray)
                }
                
                
            }
            .padding(.horizontal)
        }
        .frame(height: 50)
        .background(Color(.systemGray6))
    }
    
    
    var numberAndTxtFeild : some View{
        VStack(alignment: .leading, spacing: 0){
            Divider()
            NavigationLink {
                CountriesListView(SelectedCountry: $SelectedCountry)
            } label: {
                
                Text(SelectedCountry.name)
                    .font(.system(size: 20, weight: .medium))
                    .multilineTextAlignment(.leading)
                    .foregroundStyle(Color.blue)
                    .padding(.leading)
                    .frame(height: 50)
            }
            Divider()
                .padding(.leading, 20)
            
            HStack{
                Text(SelectedCountry.code)
                    .font(.system(size: 20, weight: .regular))
                    .frame(maxWidth: 80)
                Divider()
                
                TextField("phone number", text: $phoneNumber)
                    .font(.system(size: 25, weight: .regular))
                    .keyboardType(.numberPad)
                
            }
            .frame(height: 60)
            Divider()
        }
    }
    
   
    var emailSignIn: some View {
        
        Button {
            isNavigateToEmail = true
        } label: {
            HStack(alignment: .center) {
                // Left line
                Rectangle()
                    .fill(Color.gray)
                    .frame(height: 0.5)
                    .frame(maxWidth: .infinity)

                Text("Sign Up Using Email")
                    .font(.subheadline)
                    .foregroundColor(Color.blue)
                    .padding(.horizontal, 8)
                    .layoutPriority(1)

                Rectangle()
                    .fill(Color.gray)
                    .frame(height: 0.5)
                    .frame(maxWidth: .infinity)
            }
            .padding(.horizontal)
        }

    }
    
    
}




#Preview {
    LoginView()
}
