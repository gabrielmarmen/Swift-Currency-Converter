//
//  ContentView.swift
//  Currency Converter
//
//  Created by Gabriel Marmen on 2022-10-05.
//

import SwiftUI

struct ContentView: View {
    
    @Environment(\.scenePhase) var scenePhase
    
    @StateObject private var currencies = Currencies()
    @State private var addViewIsPresented = false
    @State private var infoViewIsPresented = false
    @State private var isReorganising = false
    @State private var exchangeRateLoadingState: LoadingState = .loading
    @EnvironmentObject var settings: Settings
    
    
    var body: some View {
            NavigationView{
                ZStack{
                    settings.backgroundColor.ignoresSafeArea(.all)
                    if currencies.chosen.count > 0 {
                        ScrollView{
                            ForEach(currencies.chosen){ currency in
                                CurrencyView(currency: currency, currencies: currencies)
                                    .padding(.horizontal, 10)
                                    .padding(.bottom, 2)
                            }
                        }
                    } else {
                        VStack{
                            Text("You don't have any currencies.")
                                .foregroundColor(.gray)
                                .font(.system(size: 15))
                            HStack{
                                Text("Tap")
                                    .foregroundColor(.gray)
                                    .font(.system(size: 15))
                                Text("Edit")
                                    .foregroundColor(.green)
                                    .foregroundColor(.gray)
                                    .font(.system(size: 15))
                                    .onTapGesture {
                                        addViewIsPresented = true
                                    }
                                Text("to add your first!")
                                    .foregroundColor(.gray)
                                    .font(.system(size: 15))
                            }
                            
                        }
                    }
                }
                .refreshable {
                    await refreshExchangeRates()
                }
                .navigationTitle("Currencies")
                .toolbar{
                    
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(){
                            addViewIsPresented = true
                        }label: {
                            Text("Edit")
                        }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(){
                            infoViewIsPresented = true
                        }label: {
                            Image(systemName: "info.circle")
                        }
                    }
                    ToolbarItem(placement: .bottomBar){
                        UpdateStatus(currentExchangeRate: $currencies.currentExchangeRate, loadingState: $exchangeRateLoadingState)
                            .padding(.bottom, 5)
                    }
                    
                }
                
            }
            .task {
                await refreshExchangeRates()
            }
            .sheet(isPresented: $addViewIsPresented, onDismiss: currencies.saveCurrencyArrayToUserDefault){
                AddView(currencies: currencies)
            }
            .sheet(isPresented: $infoViewIsPresented){
                InfoView()
            }
            .onChange(of: scenePhase) { newPhase in
                if newPhase == .active && currencies.currentExchangeRate.timestamp < Date.now.timeIntervalSince1970 - 300 {
                    Task {
                        print("App came back into focus and last refresh rate is more than 5 minutes old. Refreshing...")
                        await refreshExchangeRates()
                    }
                }
                
            }
    }
    
    func refreshExchangeRates() async  {
        exchangeRateLoadingState = .loading
        //If the exchange rates are not older than 5 minutes, mark as refreshed and loaded then returns. (This is to reduce network calls)
//        if currencies.currentExchangeRate.timestamp > Date.now.timeIntervalSince1970 - 300 {
//            exchangeRateLoadingState = .loaded
//            currencies.currentExchangeRate.refreshedAt = Date.now
//            return
//        }
        //Code that makes the exchange rates updates.
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
