//
//  InfoView.swift
//  Currency Converter
//
//  Created by Gabriel Marmen on 2022-12-29.
//

import SwiftUI

struct InfoView: View {
    @Environment(\.openURL) var openURL
    
    var body: some View {
        NavigationView{
            List{
                
                Section{
                } header: {
                    Text("About")
                } footer: {
                    Text("This app lets you calculate currency conversions for 160 currencies using the middle market rate. The rates are updated every 5 minutes. It's completely free of charge, free of ads and opensource. \n\nIf you have any problems or questions, feel free to contact me using the link bellow.")
                }
                Section{
                } header: {
                    Text("How to use")
                } footer: {
                    Text("1. Tap the 'edit' button and choose the currencies you wish to have.\n\n2. In the home page, tap the currency you want to calculate conversion from.\n\n3. Enter the amount you wish to convert and conversions will be calculated automatically.")
                }
                Section{
                    Button("Support/Contact"){
                        openURL(URL(string: "https://currencymate.gabrielmarmen.com/support.html")!)
                    }
                    Button("Privacy Policy"){
                        openURL(URL(string: "https://currencymate.gabrielmarmen.com/privacy-policy.html")!)
                    }
                    Button("My GitHub"){
                        openURL(URL(string: "https://github.com/gabrielmarmen")!)
                    }
                } header: {
                    Text("Links")
                } footer: {
                    Text("\nNeither CurrencyMate nor Gabriel Marmen can be held responsible for any errors or delays in currency data, or for any actions taken on reliance on such data. \n\nCopyright © \(String(Calendar(identifier: .gregorian).dateComponents([.year], from: .now).year!)) Gabriel Marmen")
                }
            }
            
        }
        
    }
}

struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        InfoView()
    }
}
