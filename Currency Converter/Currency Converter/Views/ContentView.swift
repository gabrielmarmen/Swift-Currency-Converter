//
//  ContentView.swift
//  Currency Converter
//
//  Created by Gabriel Marmen on 2022-10-05.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject private var currencies = Currencies()
    @State private var addViewIsPresented = false
    
    
    
    
    
    var body: some View {
        NavigationView{
            ScrollView{
                ForEach(currencies.chosen){ currency in
                    CurrencyView(currency: currency, currencies: currencies)
                        .padding(.horizontal)
                        .padding(.bottom, 1)
                }
            }
            .toolbar{
                Button("Edit"){
                    if currencies.all.isEmpty{
                        currencies.all = JsonCreator.getCurrencyArray()
                    }
                    addViewIsPresented = true
                }
            }
            .navigationTitle("Currencies")
            
        }
        .sheet(isPresented: $addViewIsPresented){
            AddView(currencies: currencies)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
