//
//  SettingView.swift
//  WhatsAppClone
//
//  Created by Manthan on 01/06/25.
//

import SwiftUI

struct SettingView: View {
    var body: some View {
        VStack{
            customNavView
            Spacer()
        }
    }
    
    var customNavView: some View{
        HStack{
            Spacer()
            Text("Setting")
                .font(.system(size: 20, weight: .medium))
            Spacer()
        }
        .frame(height: 50)
        .background(Color(.systemGray6))
    }
}

#Preview {
    SettingView()
}
