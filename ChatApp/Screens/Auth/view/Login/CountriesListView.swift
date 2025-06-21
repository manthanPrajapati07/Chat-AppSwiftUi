//
//  CountriesListView.swift
//  WhatsAppClone
//
//  Created by Manthan on 14/05/25.
//

import SwiftUI

struct CountriesListView: View {
    @Binding var SelectedCountry : Country
    @Environment(\.dismiss) private var dismiss
    @State private var searchText = ""
    
    var filterContries : [Country]{
        if searchText.isEmpty{
            return Country.countries
        }else{
            return Country.countries.filter{
                $0.name.localizedCaseInsensitiveContains(searchText) ||
                $0.code.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        NavigationView {
            List(filterContries) { country in
                Button {
                    SelectedCountry = country
                    dismiss()
                } label: {
                    HStack{
                        Text(country.name)
                            .font(.system(size: 20, weight: .medium))
                            .foregroundStyle(Color.blue)
                        Spacer()
                        Text(country.code)
                            .font(.system(size: 20, weight: .medium))
                            .foregroundStyle(Color.blue)
                    }
                }
                
            }
            
            .listStyle(.plain)
            .searchable(text: $searchText, prompt: "Search countries or codes")
            .listRowInsets(EdgeInsets())
            .navigationBarBackButtonHidden(true)
            .navigationTitle("Select Country")
            .navigationBarTitleDisplayMode(.large)
        }
        
    }
}

#Preview {
    CountriesListView(SelectedCountry: .constant(Country.init(name: "india", code: "+91", validNumberCount: 10)))
}
