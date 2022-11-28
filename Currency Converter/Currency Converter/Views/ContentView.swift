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
    @State private var isReorganising = false
    
    
    var body: some View {
        NavigationView{
            ScrollView{
                ForEach(currencies.chosen){ currency in
                    CurrencyView(currency: currency, currencies: currencies)
                        .padding(.horizontal, 10)
                        .padding(.bottom, 1)
                }
            }
            .refreshable {
                await refreshExchangeRates()
            }
            .toolbar{
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(){
                        isReorganising.toggle()
                    }label: {
                        if isReorganising {
                            Text("Done")
                        } else {
                            Image(systemName: "line.horizontal.3")
                                .disabled(currencies.chosen.isEmpty)
                        }
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(){
                        addViewIsPresented = true
                    }label: {
                        Image(systemName: "plus")
                    }
                }
                

//         ----------Buttons for debugging-----------
//                Button("Add All") {
//                    for currency in currencies.all {
//                        currency.enable(currencies: currencies)
//
//                    }
//                }
//                Button("Delete All") {
//                    for currency in currencies.all {
//                        currency.disable(currencies: currencies)
//                    }
//                    currencies.deleteCurrencyArrayUserDefault()
//                }
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
