//
//  AddProfileDetailsView.swift
//  WhatsAppClone
//
//  Created by Manthan on 19/05/25.
//

import SwiftUI

struct AddProfileDetailsView: View {
    var body: some View {
        NavigationView{
            VStack{
                CustomNavigationBar
                    .frame(maxWidth: .infinity)
                
                Spacer()
            }
        }
        .navigationBarBackButtonHidden()
    }
}

var CustomNavigationBar: some View {
    HStack {
        Text("Add Profile Details")
            .font(.system(size: 20, weight: .semibold))
    }
    .frame(maxWidth: .infinity, maxHeight: 50)
    .background(Color(.systemGray6))
}


#Preview {
    AddProfileDetailsView()
}
