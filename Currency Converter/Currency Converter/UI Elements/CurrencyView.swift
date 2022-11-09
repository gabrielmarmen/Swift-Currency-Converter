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
                    .scaledToFill()
                    .frame(width: 60, height: 45)
                    .clipShape(RoundedRectangle(cornerRadius: 7))
                    .overlay(
                            RoundedRectangle(cornerRadius: 7)
                                .stroke(.gray.opacity(0.3), lineWidth: 1)
                        )
                    
                // Button("Modify Currency"){
                //    currency.calculatedValue = Double.random(in: 0.0...10)
                // }
                VStack(alignment: .leading){
                    Text(currency.code)
                        .font(.headline)
                        .foregroundColor(.primary)
                        .frame(maxWidth: 100, maxHeight: 5, alignment: .leading)
                        .padding(.bottom, 7)
                        
                    Text(currency.name)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: 500, maxHeight: 5, alignment: .leading)
                       
                }
            }
            VStack{
                Text(String(currency.formatedValue))
                    .foregroundColor(.primary)
                    .font(.headline)
                    .padding(.all, 5)
            }
            .background(
                Rectangle()
                    .background(Material.thinMaterial.opacity(0.7))
                    .clipShape(RoundedRectangle(cornerRadius: 7))
            )
            .frame( maxHeight: 30, alignment: .trailing)
            .onTapGesture {
                isShowingNumberPad = true
            }
            
        }
        .padding()
        .frame(maxWidth: .infinity, minHeight: 75)
        .background(
            currency.flagImage
            .resizable()
            .scaledToFill()
            .scaleEffect(1.1)
            .opacity(0.5)
            .blur(radius: 15)
        )
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .strokeBorder(.gray.opacity(currency.isSelected ? 0.75 : 0.30), lineWidth: currency.isSelected ? 2 : 1)
            )
        .sheet(isPresented: $isShowingNumberPad) {
            NumpadView(currency: currency, currencies: currencies)
                .presentationDetents([.height(225)])
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
