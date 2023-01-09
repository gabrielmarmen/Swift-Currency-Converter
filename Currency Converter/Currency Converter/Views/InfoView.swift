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
                    Text("This app let's you convert 160 currencies using the middle market rate. The rates are updated every 5 minutes. It is completly free of charge, free of ads and opensource. \n\nIf you have any problems or questions, feel free to contact me using the link bellow")
                }
                Section{
                    Button("Contact Me"){
                        openURL(URL(string: "https://www.gabrielmarmen.com")!)
                    }
                    Button("My Website"){
                        openURL(URL(string: "https://www.gabrielmarmen.com")!)
                    }
                    Button("My GitHub"){
                        openURL(URL(string: "https://github.com/gabrielmarmen")!)
                    }
                } header: {
                    Text("Links")
                } footer: {
                    Text("Neither CurrencyMate nor Gabriel Marmen can be held responsible for any errors or delays in currency data, or for any actions taken on reliance on such data. \n\nCopyright © Gabriel Marmen \(String(Calendar(identifier: .gregorian).dateComponents([.year], from: .now).year ?? 2022)) ")
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
