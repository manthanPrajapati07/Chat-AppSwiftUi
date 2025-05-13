//
//  ContentView.swift
//  WhatsAppClone
//
//  Created by Manthan on 13/05/25.
//

import SwiftUI

struct ContentView: View {
    
    @State var isActive : Bool = false
    
    var body: some View {
        VStack {
            if isActive{
                LoginView()
            }else{
                SplashView()
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0){
                isActive.toggle()
            }
        }
    }
}

#Preview {
    ContentView()
}
