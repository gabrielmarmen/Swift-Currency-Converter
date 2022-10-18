//
//  NumpadView.swift
//  Currency Converter
//
//  Created by Gabriel Marmen on 2022-10-07.
//

import SwiftUI
import Introspect

struct NumpadView: View {
    
    
    @Environment(\.dismiss) var dismiss
    @StateObject var currency: Currency
    @StateObject var currencies: Currencies
    @State private var fieldValue = 0.0
    @FocusState private var textFieldIsFocused: Bool
    
    
    

    
    var body: some View {
        
            VStack {
                Text("Enter Amount")
                    .font(.largeTitle.bold())
                TextField("Enter currency amount", value: $fieldValue, formatter: currency.numberFormatter)
                    .padding(.bottom)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)
                    .onChange(of: currency.inputValue) { _ in
                        currencies.CalculateConversions()
                    }
                    .onChange(of: textFieldIsFocused) { _ in
                        if textFieldIsFocused == false {
                            dismiss()
                        }
                    }
                    .onAppear(perform: ConfigureView)
                    .introspectTextField { textField in
                        textField.becomeFirstResponder()
                    }
                    .focused($textFieldIsFocused)
                
                Button(){
                    currency.inputValue = fieldValue
                    dismiss()
                }label: {
                    Label("Convert", systemImage: "arrow.left.arrow.right")
                        .foregroundColor(.white)
                        .font(.headline.bold())
                        .frame(maxWidth: .infinity)
                }
                .padding(.vertical)
                .frame(maxWidth: .infinity)
                .contentShape(Rectangle())
                .background(.blue)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                
                

                
            }
            .padding(.horizontal)
            .navigationTitle("Enter Amount")
    }
    
    
    func ConfigureView() {
        currencies.SetInputValues(selectedCurrency: currency)
        fieldValue = currency.calculatedValue
        print(currencies.selectedCurrency.code + " is Selected")
    }
    

    
}

struct NumpadView_Previews: PreviewProvider {
    static var previews: some View {
        
            NumpadView(currency: Currency.exempleCurrencyFrance(), currencies: Currencies())
                .environmentObject(Currencies())
        
        
    }
}
