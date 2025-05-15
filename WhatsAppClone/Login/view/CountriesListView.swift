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
            return countries
        }else{
            return countries.filter{
                $0.name.localizedCaseInsensitiveContains(searchText) ||
                $0.code.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    let countries: [Country] = [
        Country(name: "India", code: "+91", validNumberCount: 10),
            Country(name: "United States", code: "+1", validNumberCount: 10),
            Country(name: "United Kingdom", code: "+44", validNumberCount: 10),
            Country(name: "Australia", code: "+61", validNumberCount: 9),
            Country(name: "Germany", code: "+49", validNumberCount: 10),
            Country(name: "France", code: "+33", validNumberCount: 9),
            Country(name: "Brazil", code: "+55", validNumberCount: 11),
            Country(name: "Russia", code: "+7", validNumberCount: 10),
            Country(name: "Pakistan", code: "+92", validNumberCount: 10),
            Country(name: "Bangladesh", code: "+880", validNumberCount: 10),
            Country(name: "Canada", code: "+1", validNumberCount: 10),
            Country(name: "China", code: "+86", validNumberCount: 11),
            Country(name: "Japan", code: "+81", validNumberCount: 10),
            Country(name: "Indonesia", code: "+62", validNumberCount: 10),
            Country(name: "Nigeria", code: "+234", validNumberCount: 10),
            Country(name: "Nepal", code: "+977", validNumberCount: 10),
            Country(name: "Sri Lanka", code: "+94", validNumberCount: 9),
            Country(name: "South Korea", code: "+82", validNumberCount: 10),
            Country(name: "South Africa", code: "+27", validNumberCount: 9),
            Country(name: "Malaysia", code: "+60", validNumberCount: 9)]
    
    var body: some View {
        NavigationStack {
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
