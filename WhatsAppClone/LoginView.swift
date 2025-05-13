//
//  LoginView.swift
//  WhatsAppClone
//
//  Created by Manthan on 13/05/25.
//

import SwiftUI

struct LoginView: View {
    var body: some View {
        
        GeometryReader{ geometry in
            VStack(spacing: 0) {
                
                CustomNavigationBar
                  
                Text("Please confirm your country code and enter your phone number")
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: geometry.size.width * 0.8)
                    .padding(30)
                
                Spacer()
            }
        }
        
    }
    
    var CustomNavigationBar: some View {
        ZStack {
            Text("Phone number")
                .font(.system(size: 20, weight: .semibold))
            HStack {
               Spacer()
                Text("Done")
                    .font(.system(size: 20))
                    .foregroundColor(.gray)
            }
            .padding(.horizontal)
        }
        .frame(height: 50)
        .background(Color(.systemGray6))
    }
    
    
    
}




#Preview {
    LoginView()
}
