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
        Country(name: "Afghanistan", code: "+93"),
        Country(name: "Albania", code: "+355"),
        Country(name: "Algeria", code: "+213"),
        Country(name: "Andorra", code: "+376"),
        Country(name: "Angola", code: "+244"),
        Country(name: "Argentina", code: "+54"),
        Country(name: "Armenia", code: "+374"),
        Country(name: "Australia", code: "+61"),
        Country(name: "Austria", code: "+43"),
        Country(name: "Azerbaijan", code: "+994"),
        Country(name: "Bahamas", code: "+1-242"),
        Country(name: "Bahrain", code: "+973"),
        Country(name: "Bangladesh", code: "+880"),
        Country(name: "Belarus", code: "+375"),
        Country(name: "Belgium", code: "+32"),
        Country(name: "Belize", code: "+501"),
        Country(name: "Benin", code: "+229"),
        Country(name: "Bhutan", code: "+975"),
        Country(name: "Bolivia", code: "+591"),
        Country(name: "Bosnia and Herzegovina", code: "+387"),
        Country(name: "Botswana", code: "+267"),
        Country(name: "Brazil", code: "+55"),
        Country(name: "Brunei", code: "+673"),
        Country(name: "Bulgaria", code: "+359"),
        Country(name: "Burkina Faso", code: "+226"),
        Country(name: "Burundi", code: "+257"),
        Country(name: "Cambodia", code: "+855"),
        Country(name: "Cameroon", code: "+237"),
        Country(name: "Canada", code: "+1"),
        Country(name: "Cape Verde", code: "+238"),
        Country(name: "Central African Republic", code: "+236"),
        Country(name: "Chad", code: "+235"),
        Country(name: "Chile", code: "+56"),
        Country(name: "China", code: "+86"),
        Country(name: "Colombia", code: "+57"),
        Country(name: "Comoros", code: "+269"),
        Country(name: "Congo (Brazzaville)", code: "+242"),
        Country(name: "Congo (Kinshasa)", code: "+243"),
        Country(name: "Costa Rica", code: "+506"),
        Country(name: "Croatia", code: "+385"),
        Country(name: "Cuba", code: "+53"),
        Country(name: "Cyprus", code: "+357"),
        Country(name: "Czech Republic", code: "+420"),
        Country(name: "Denmark", code: "+45"),
        Country(name: "Djibouti", code: "+253"),
        Country(name: "Dominica", code: "+1-767"),
        Country(name: "Dominican Republic", code: "+1-809"),
        Country(name: "Ecuador", code: "+593"),
        Country(name: "Egypt", code: "+20"),
        Country(name: "El Salvador", code: "+503"),
        Country(name: "Equatorial Guinea", code: "+240"),
        Country(name: "Eritrea", code: "+291"),
        Country(name: "Estonia", code: "+372"),
        Country(name: "Eswatini", code: "+268"),
        Country(name: "Ethiopia", code: "+251"),
        Country(name: "Fiji", code: "+679"),
        Country(name: "Finland", code: "+358"),
        Country(name: "France", code: "+33"),
        Country(name: "Gabon", code: "+241"),
        Country(name: "Gambia", code: "+220"),
        Country(name: "Georgia", code: "+995"),
        Country(name: "Germany", code: "+49"),
        Country(name: "Ghana", code: "+233"),
        Country(name: "Greece", code: "+30"),
        Country(name: "Grenada", code: "+1-473"),
        Country(name: "Guatemala", code: "+502"),
        Country(name: "Guinea", code: "+224"),
        Country(name: "Guinea-Bissau", code: "+245"),
        Country(name: "Guyana", code: "+592"),
        Country(name: "Haiti", code: "+509"),
        Country(name: "Honduras", code: "+504"),
        Country(name: "Hungary", code: "+36"),
        Country(name: "Iceland", code: "+354"),
        Country(name: "India", code: "+91"),
        Country(name: "Indonesia", code: "+62"),
        Country(name: "Iran", code: "+98"),
        Country(name: "Iraq", code: "+964"),
        Country(name: "Ireland", code: "+353"),
        Country(name: "Israel", code: "+972"),
        Country(name: "Italy", code: "+39"),
        Country(name: "Jamaica", code: "+1-876"),
        Country(name: "Japan", code: "+81"),
        Country(name: "Jordan", code: "+962"),
        Country(name: "Kazakhstan", code: "+7"),
        Country(name: "Kenya", code: "+254"),
        Country(name: "Kiribati", code: "+686"),
        Country(name: "Kuwait", code: "+965"),
        Country(name: "Kyrgyzstan", code: "+996"),
        Country(name: "Laos", code: "+856"),
        Country(name: "Latvia", code: "+371"),
        Country(name: "Lebanon", code: "+961"),
        Country(name: "Lesotho", code: "+266"),
        Country(name: "Liberia", code: "+231"),
        Country(name: "Libya", code: "+218"),
        Country(name: "Liechtenstein", code: "+423"),
        Country(name: "Lithuania", code: "+370"),
        Country(name: "Luxembourg", code: "+352"),
        Country(name: "Madagascar", code: "+261"),
        Country(name: "Malawi", code: "+265"),
        Country(name: "Malaysia", code: "+60"),
        Country(name: "Maldives", code: "+960"),
        Country(name: "Mali", code: "+223"),
        Country(name: "Malta", code: "+356"),
        Country(name: "Marshall Islands", code: "+692"),
        Country(name: "Mauritania", code: "+222"),
        Country(name: "Mauritius", code: "+230"),
        Country(name: "Mexico", code: "+52"),
        Country(name: "Micronesia", code: "+691"),
        Country(name: "Moldova", code: "+373"),
        Country(name: "Monaco", code: "+377"),
        Country(name: "Mongolia", code: "+976"),
        Country(name: "Montenegro", code: "+382"),
        Country(name: "Morocco", code: "+212"),
        Country(name: "Mozambique", code: "+258"),
        Country(name: "Myanmar", code: "+95"),
        Country(name: "Namibia", code: "+264"),
        Country(name: "Nauru", code: "+674"),
        Country(name: "Nepal", code: "+977"),
        Country(name: "Netherlands", code: "+31"),
        Country(name: "New Zealand", code: "+64"),
        Country(name: "Nicaragua", code: "+505"),
        Country(name: "Niger", code: "+227"),
        Country(name: "Nigeria", code: "+234"),
        Country(name: "North Korea", code: "+850"),
        Country(name: "North Macedonia", code: "+389"),
        Country(name: "Norway", code: "+47"),
        Country(name: "Oman", code: "+968"),
        Country(name: "Pakistan", code: "+92"),
        Country(name: "Palau", code: "+680"),
        Country(name: "Panama", code: "+507"),
        Country(name: "Papua New Guinea", code: "+675"),
        Country(name: "Paraguay", code: "+595"),
        Country(name: "Peru", code: "+51"),
        Country(name: "Philippines", code: "+63"),
        Country(name: "Poland", code: "+48"),
        Country(name: "Portugal", code: "+351"),
        Country(name: "Qatar", code: "+974"),
        Country(name: "Romania", code: "+40"),
        Country(name: "Russia", code: "+7"),
        Country(name: "Rwanda", code: "+250"),
        Country(name: "Saint Kitts and Nevis", code: "+1-869"),
        Country(name: "Saint Lucia", code: "+1-758"),
        Country(name: "Saint Vincent and the Grenadines", code: "+1-784"),
        Country(name: "Samoa", code: "+685"),
        Country(name: "San Marino", code: "+378"),
        Country(name: "Sao Tome and Principe", code: "+239"),
        Country(name: "Saudi Arabia", code: "+966"),
        Country(name: "Senegal", code: "+221"),
        Country(name: "Serbia", code: "+381"),
        Country(name: "Seychelles", code: "+248"),
        Country(name: "Sierra Leone", code: "+232"),
        Country(name: "Singapore", code: "+65"),
        Country(name: "Slovakia", code: "+421"),
        Country(name: "Slovenia", code: "+386"),
        Country(name: "Solomon Islands", code: "+677"),
        Country(name: "Somalia", code: "+252"),
        Country(name: "South Africa", code: "+27"),
        Country(name: "South Korea", code: "+82"),
        Country(name: "South Sudan", code: "+211"),
        Country(name: "Spain", code: "+34"),
        Country(name: "Sri Lanka", code: "+94"),
        Country(name: "Sudan", code: "+249"),
        Country(name: "Suriname", code: "+597"),
        Country(name: "Sweden", code: "+46")]
    
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
    CountriesListView(SelectedCountry: .constant(Country.init(name: "india", code: "+91")))
}
