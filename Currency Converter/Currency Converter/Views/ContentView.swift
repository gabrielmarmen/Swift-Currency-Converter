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
    @State private var exchangeRateLoadingState: LoadingState = .loading
    @EnvironmentObject var settings: Settings
    
    
    var body: some View {
            NavigationView{
                ZStack{
                    settings.backgroundColor.ignoresSafeArea(.all)
                    
                    ScrollView{
                        ForEach(currencies.chosen){ currency in
                            CurrencyView(currency: currency, currencies: currencies)
                                .padding(.horizontal, 10)
                                .padding(.bottom, 2)
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
                        ToolbarItem(placement: .navigationBarTrailing){
                            Button("Hello"){
                                
                                exchangeRateLoadingState = .failedLoading
                            }
                        }
                        ToolbarItem(placement: .bottomBar){
                            UpdateStatus(currentExchangeRate: $currencies.currentExchangeRate, loadingState: $exchangeRateLoadingState)
                                .padding(.bottom, 5)
                        }
                        
                    }
                    .navigationTitle("Currencies")
                }
                
            }
            .task {
                await refreshExchangeRates()
            }
            .sheet(isPresented: $addViewIsPresented, onDismiss: currencies.saveCurrencyArrayToUserDefault){
                AddView(currencies: currencies)
            }
            
            
    }
    
    func refreshExchangeRates() async  {
        exchangeRateLoadingState = .loading
        if let updatedExchangeRate = await ExchangeRate.getLatestExchangeRate() {
            currencies.updateExchangeRate(with: updatedExchangeRate)
            exchangeRateLoadingState = .loaded
        } else {
            print("Could not get latest exchange rates...")
            exchangeRateLoadingState = .failedLoading
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(Settings())
    }
}
