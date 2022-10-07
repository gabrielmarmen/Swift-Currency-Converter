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
    
    private let numberFormatter = NumberFormatter()

    
    var body: some View {
        NavigationView{
            List{
                TextField("Enter Amount", value: $currency.calculatedValue, formatter: numberFormatter)
                    
                Text(currency.code)
                Button("Done"){
                    
                }
            }
           
        }
        .onAppear(perform: SetCurrencyAsSelected)
    
    }
    
    func SetCurrencyAsSelected(){
        currencies.SetInputValue(selectedCurrency: currency)
        print(currencies.selectedCurrency.code + " is Selected")
    }
    
    func ConfigureNumberFormatter(){
        numberFormatter.numberStyle = .currency
        numberFormatter.maximumFractionDigits = 2
        numberFormatter.currencyCode = currency.code
    }
}

struct NumpadView_Previews: PreviewProvider {
    static var previews: some View {
        NumpadView(currency: Currency.exempleCurrencyFrance(), currencies: Currencies())
            .environmentObject(Currencies())
    }
}
