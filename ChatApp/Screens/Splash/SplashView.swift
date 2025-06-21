//
//  SplashView.swift
//  WhatsAppClone
//
//  Created by Manthan on 13/05/25.
//

import SwiftUI

struct SplashView: View {
    var body: some View {
        GeometryReader { geometry in
            HStack{
                VStack{
                    Spacer()
                    
                    splashIcn
                        .frame(width: geometry.size.width * 0.3)
                    
                    Spacer()
                    
                    titleView
                        .padding(.bottom,30)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
    
    
    var splashIcn: some View {
        Image("Splash_icn")
            .resizable()
            .aspectRatio(1, contentMode: .fit)
    }
    
    
    var titleView: some View {
        VStack(spacing: 4) {
            Text("form")
                .font(.system(size: 20, weight: .regular))
            Text("MANTHAN")
                .font(.system(size: 22, weight: .bold))
        }
    }
}

#Preview {
    SplashView()
}
