//
//  NumpadView.swift
//  Currency Converter
//
//  Created by Gabriel Marmen on 2022-10-07.
//

import SwiftUI
import Introspect
import SwiftUIKit

struct NumpadView: View {
    
    
    @Environment(\.dismiss) var dismiss
    @StateObject var currency: Currency
    @StateObject var currencies: Currencies
    @State private var textFieldValue: Double? = 0.0
    @FocusState private var textFieldIsFocused: Bool
    
    var body: some View {
        
            VStack {
                Text("Enter Amount")
                    .font(.largeTitle.bold())
                
                CurrencyTextField("Amount", value: $textFieldValue, alwaysShowFractions: false, numberOfDecimalPlaces: currency.maxDecimal, currencySymbol: currency.symbol)
                    .font(.largeTitle)
                    .multilineTextAlignment(TextAlignment.center)
                    .padding(.bottom)
                    .keyboardType(.numberPad)
                    .introspectTextField { textField in
                        textField.becomeFirstResponder()
                    }
                    .onChange(of: textFieldValue) { _ in
                        currency.setInputValue(with: textFieldValue, currencies: currencies)
                        currencies.CalculateConversions()
                    }
                    .onChange(of: textFieldIsFocused) { _ in
                        if textFieldIsFocused == false {
                            dismiss()
                        }
                    }
                    .focused($textFieldIsFocused)
                
                Button(){
                    dismiss()
                }label: {
                    Label("Done", systemImage: "checkmark.circle.fill")
                        .foregroundColor(.white)
                        .font(.headline.bold())
                        .frame(maxWidth: .infinity)
                }
                .padding(.vertical)
                .frame(maxWidth: .infinity)
                .contentShape(Rectangle())
                .background(Color.accentColor)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            .padding(.horizontal)
            .navigationTitle("Enter Amount")
            .onAppear(perform: ConfigureView)
            
            
    }
    
    
    func ConfigureView() {
        currencies.SetAsSelected(selectedCurrency: currency)
    }
}

struct NumpadView_Previews: PreviewProvider {
    static var previews: some View {
        
            NumpadView(currency: Currency.exempleCurrencyFrance(), currencies: Currencies())
                .environmentObject(Currencies())
        
        
    }
}
