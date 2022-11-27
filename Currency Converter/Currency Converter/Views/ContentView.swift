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
            .refreshable {
                await refreshExchangeRates()
            }
            .toolbar{
                Button("Edit"){
                    addViewIsPresented = true
                }
            }
            .navigationTitle("Currencies")
            
        }
        .task {
            await refreshExchangeRates()
        }
        .sheet(isPresented: $addViewIsPresented, onDismiss: currencies.saveCurrencyArrayToUserDefault){
            AddView(currencies: currencies)
        }
    }
    
    func refreshExchangeRates() async {
        if let updatedExchangeRate = await ExchangeRate.getLatestExchangeRate() {
            currencies.updateExchangeRate(with: updatedExchangeRate)
        } else {
            //put code to show error message and make haptic feed back
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
