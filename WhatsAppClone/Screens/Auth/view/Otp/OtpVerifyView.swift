//
//  OtpVerifyView.swift
//  WhatsAppClone
//
//  Created by Manthan on 18/05/25.
//

import SwiftUI

struct OtpVerifyView: View {
    
    @State private var otp: String = ""
    @FocusState private var isOTPFieldFocused: Bool
    @State private var timer : Timer?
    @State private var remainingTime = 60
    @State private var isResendtimer : Bool = false
    @EnvironmentObject var authVM : AuthViewModel
    @Binding var phoneNumber : String
    @Environment(\.dismiss) private var dismiss
    
    @State private var navigateToAddProfile = false
    @State private var navigateToHome = false
    
    var formattedTime: String {
        let minutes = remainingTime / 60
        let seconds = remainingTime % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    
    init(phoneNumber: Binding<String>) {
        self._phoneNumber = phoneNumber
    }
    
    var body: some View {
        NavigationView{
            GeometryReader{ geometry in
                VStack{
                    CustomNavigationBar
                    
                    VStack{
                        Text("We have sent you an SMS with a code to the number above")
                            .font(.system(size: 20, weight: .regular))
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: geometry.size.width * 0.8)
                            .padding()
                            .padding(.top, 30)
                        
                        Text("To complete your phone number verification, please enter the 6-digit activation code.")
                            .font(.system(size: 20, weight: .regular))
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: geometry.size.width * 0.8)
                    }
                    
                    OtpFieldView
                        .padding()
                        .frame(maxWidth: geometry.size.width * 0.6, maxHeight: 50)
                        .padding(.top, 30)
                    
                    HStack{
                        Text("Didn't receive a verification code?")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundStyle(Color.gray)
                        
                        Button {
//                            AppFunctions.showLoader()
                            authVM.sendOTP(to: phoneNumber)
                            startTimer()
                        } label: {
                            Text("Resend")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundStyle(isResendtimer ? Color.blue : Color.gray)
                                .multilineTextAlignment(.leading)
                        }
                        
                        
                        
                    }
                    .frame(maxWidth: geometry.size.width * 0.8)
                    .padding()
                    
                    HStack{
                        Text("You may request a new code in")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundStyle(Color.gray)
                        
                        Text(formattedTime)
                            .font(.system(size: 16, weight: .medium))
                            .foregroundStyle(Color.black)
                            .multilineTextAlignment(.leading)
                        
                    }
                    .frame(maxWidth: geometry.size.width * 0.8)
                    
                    
                    Spacer()
                }
                
                .onAppear {
                    startTimer()
                }
            }
        }
        .navigationBarBackButtonHidden()
//        .onChange(of: authVM.isNewUser) { isNew in
//            if isNew {
//                navigateToAddProfile = true
//                navigateToHome = false
//            } else {
//                navigateToAddProfile = false
//                navigateToHome = true
//            }
//        }
//        
//        NavigationLink(
//            destination: AddProfileDetailsView(),
//            isActive: $navigateToAddProfile
//        ) {
//            EmptyView()
//        }
//        .padding()
//        
//        NavigationLink(
//            destination: HomeScreenView(),
//            isActive: $navigateToHome
//        ) {
//            EmptyView()
//        }
//        .padding()
//        .environmentObject(authVM)
    }
    
    var CustomNavigationBar: some View {
        Button {
            dismiss()
        } label: {
            HStack{
                Image("left_Arrow_icn")
                    .renderingMode(.template)
                    .resizable()
                    .aspectRatio(1, contentMode: .fit)
                    .frame(height: 20)
                    .foregroundColor(.blue)
                    .padding(.leading)
                
                Text("Edit \(phoneNumber)")
                    .font(.system(size: 20, weight: .regular))
                    .foregroundStyle(Color.blue)
            }
            .frame(maxWidth: .infinity, maxHeight: 50, alignment: .leading)
            .background(Color(.systemGray6))
            
        }
    }
    
    var OtpFieldView : some View{
        VStack{
            OTPFieldView(numberOfFields: 6, otp: $otp)
                .onChange(of: otp) { newOtp in
                    if newOtp.count == 6 {
                        authVM.verifyOTP(otp)
                    }
                }
                .focused($isOTPFieldFocused)
        }
    }
    
    
     func startTimer() {
        timer?.invalidate()  // Invalidate any existing timer
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if remainingTime > 0 {
                remainingTime -= 1
            } else {
                timer?.invalidate()
                isResendtimer = true
            }
        }
    }
    
   
}

#Preview {
    OtpVerifyView(phoneNumber: .constant("1234567"))
}
