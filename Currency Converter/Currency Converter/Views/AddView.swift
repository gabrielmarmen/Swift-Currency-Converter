//
//  AddView.swift
//  Currency Converter
//
//  Created by Gabriel Marmen on 2022-11-09.
//

import SwiftUI

struct AddView: View {
    
    @Binding var allCurrencies: [Currency]
    
    var body: some View {
        NavigationView{
            List{
                ForEach($allCurrencies){ $currency in
                    HStack{
                        Text(currency.name)
                        Spacer()
                        CheckBoxView(checked: $currency.enabled)
                    }
                }
            }
            .listStyle(.plain)
            .navigationTitle("Sheesh")
        }
    }
}

struct AddView_Previews: PreviewProvider {
    @State static var allCurrencies = [Currency.exempleCurrencyFrance(), Currency.exempleCurrencyAfghanistan()]
    static var previews: some View {
        
        AddView(allCurrencies: $allCurrencies)
    }
}
