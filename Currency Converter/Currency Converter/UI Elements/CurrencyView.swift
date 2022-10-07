//
//  CurrencyView.swift
//  Currency Converter
//
//  Created by Gabriel Marmen on 2022-10-05.
//

import SwiftUI
import FlagKit



struct CurrencyView: View {
    
    
    //Currency currently being shown on screen
    @StateObject var currency: Currency
    @StateObject var currencies: Currencies
    @State private var isShowingNumberPad = false

    
    var body: some View {
        HStack{
            HStack{
                currency.flagImage
                    .resizable()
                    .scaledToFit()
                    .frame(height: 50)
                    .clipShape(RoundedRectangle(cornerRadius: 7))
                // Button("Modify Currency"){
                //    currency.calculatedValue = Double.random(in: 0.0...10)
                // }
                VStack(alignment: .leading){
                    Text(currency.code)
                        .font(.headline)
                        .foregroundColor(.primary)
                    Text(currency.name)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
            }
            
            Spacer()
            VStack{
                Text(String(currency.formatedValue))
                    .foregroundColor(.primary)
                    .font(.title)
                    .padding(.all, 5)
                    
            }
            .onTapGesture {
                isShowingNumberPad = true
            }
            .background(
                Rectangle()
                    .background(currency.isSelected ? Material.thickMaterial.opacity(1) : Material.thinMaterial.opacity(0.2))
                    .clipShape(RoundedRectangle(cornerRadius: 7))
            )
        }
        .padding()
        .frame(maxWidth: .infinity, minHeight: 100)
        .background(
            currency.flagImage
            .resizable()
            .scaledToFill()
            .scaleEffect(1.1)
            .opacity(0.5)
            .blur(radius: 15)
        )
        .clipShape(RoundedRectangle(cornerRadius: 7))
        
        .sheet(isPresented: $isShowingNumberPad) {
            NumpadView(currency: currency, currencies: currencies)
        }
        
        
        
    }
}

struct CurrencyView_Previews: PreviewProvider {
    static var previews: some View {
        
        NavigationView{
            CurrencyView(currency: Currency.exempleCurrencyFrance(), currencies: Currencies())
        }
    }
}
