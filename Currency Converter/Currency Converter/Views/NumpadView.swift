//
//  NumpadView.swift
//  Currency Converter
//
//  Created by Gabriel Marmen on 2022-10-07.
//

import SwiftUI

struct NumpadView: View {
    
    
    @Environment(\.dismiss) var dismiss
    @StateObject var currency: Currency
    @StateObject var currencies: Currencies
    
    
    

    
    var body: some View {
        NavigationView{
            List{
                TextField("Enter Value", value: $currency.inputValue, formatter: currencies.numberFormatter)
                    .onChange(of: currency.inputValue) { _ in
                        currencies.CalculateConversions()
                    }
                Text(currency.code)
                Button("Done"){
                    dismiss()
                }
            }
           
        }
        .onAppear(perform: ConfigureView)
        
    
    }
    
    func ConfigureView() {
        currencies.SetInputValues(selectedCurrency: currency)
        print(currencies.selectedCurrency.code + " is Selected")
        print("View Configured")
    }
    

    
}

struct NumpadView_Previews: PreviewProvider {
    static var previews: some View {
        NumpadView(currency: Currency.exempleCurrencyFrance(), currencies: Currencies())
            .environmentObject(Currencies())
    }
}
