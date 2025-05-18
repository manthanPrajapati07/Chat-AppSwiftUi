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
      private let numberOfFieldsInOTP = 6
    
   
    
    var body: some View {
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
                
           
                Spacer()
            }
        }
    }
    
    var CustomNavigationBar: some View {
        HStack{
            Image("left_Arrow_icn")
                .renderingMode(.template)
                .resizable()
                .aspectRatio(1, contentMode: .fit)
                .frame(height: 30)
                .foregroundColor(.blue)
                .padding(.leading)
            
            Text("Edit")
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(Color.blue)
        }
        .frame(maxWidth: .infinity, maxHeight: 50, alignment: .leading)
        .background(Color(.systemGray6))
        
    }
    
    var OtpFieldView : some View{
        VStack{
            OTPFieldView(numberOfFields: numberOfFieldsInOTP, otp: $otp)
                .onChange(of: otp) { newOtp in
                    if newOtp.count == numberOfFieldsInOTP {
                        
                    }
                }
                .focused($isOTPFieldFocused)
            
            Text("Entered OTP: \(otp)")
        }
    }
    
    

}

#Preview {
    OtpVerifyView()
}
