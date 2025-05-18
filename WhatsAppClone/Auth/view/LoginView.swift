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
    
    private var authVM = AuthViewModel.shared

    
    var isValidNumber: Bool {
        phoneNumber.count > SelectedCountry.validNumberCount
    }
    
    var body: some View {
        
        NavigationStack{
            GeometryReader{ geometry in
                
                VStack(spacing: 0) {
                    CustomNavigationBar
                    
                    Text("Please confirm your country code and enter your phone number")
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: geometry.size.width * 0.8)
                        .padding(30)
                    
                    numberAndTxtFeild
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Spacer()
                }
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
                        authVM.sendOTP(to: phoneNumber) { success in
                            switch success{
                            case .success():
                                break
                            case .failure(_):
                                break
                            }
                        }
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
            .frame(maxHeight: 60)
            Divider()
        }
    }
    
    
}




#Preview {
    LoginView()
}
