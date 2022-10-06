//
//  ContentView.swift
//  Currency Converter
//
//  Created by Gabriel Marmen on 2022-10-05.
//

import SwiftUI

struct ContentView: View {
    
    
    
    
    @StateObject private var currencies = Currencies()
    
    var body: some View {
        NavigationView{
            List{
                ForEach(currencies.chosen){ currency in
                    CurrencyView(currency: currency)
                }
            }
            .toolbar{
                Button("Add"){
                    currencies.all.append(Currency.exempleCurrencyAfghanistan())
                    currencies.all.append(Currency.exempleCurrencyFrance())
                }
            }
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
