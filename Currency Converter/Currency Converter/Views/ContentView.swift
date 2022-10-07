//
//  ContentView.swift
//  Currency Converter
//
//  Created by Gabriel Marmen on 2022-10-05.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject private var currencies = Currencies()
    
    
    //This returns the currently selected currency (One being modified)
    //Loop through the currencies to see which one has a non nil input.
    //Every currencies is supposed to have a nil value except the one that is currenctly selected to be converted
    var selectedCurrency: Currency? {
        for currency in currencies.chosen {
            if currency.inputValue != nil {
                return currency
            }
        }
        return nil
    }
    
    
    var body: some View {
        NavigationView{
            ScrollView{
                ForEach(currencies.chosen){ currency in
                    CurrencyView(currency: currency)
                        .padding(.horizontal)
                        .padding(.bottom, 10)
                }
            }
            .toolbar{
                Button("Add"){
                    currencies.all.append(Currency.exempleCurrencyAfghanistan())
                    currencies.all.append(Currency.exempleCurrencyFrance())
                }
            }
            .navigationTitle("Currencies")
            
        }
        
        
        
        
    }
    
    
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
