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
            currency.flagImage
                .resizable()
                .scaledToFill()
                .frame(width: 60, height: 45)
                .clipShape(RoundedRectangle(cornerRadius: 7))
                .overlay(
                    RoundedRectangle(cornerRadius: 7)
                        .stroke(.gray.opacity(0.3), lineWidth: 1)
                )
            
            VStack(alignment: .leading){
                Text(currency.code)
                    .font(.headline)
                    .foregroundColor(.primary)
                    .frame(maxHeight: 5, alignment: .leading)
                    .padding(.bottom, 7)
                
                Text(currency.name)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .frame(maxHeight: 5, alignment: .leading)
                
            }
            
            .frame(minWidth: 5)
            Text(String(currency.formatedValue))
                .foregroundColor(.primary)
                .font(.headline)
                .padding(.all, 5)
                .background(
                    Rectangle()
                        .background(Material.thinMaterial.opacity(0.7))
                        .clipShape(RoundedRectangle(cornerRadius: 7))
                )
                .frame( maxWidth: .infinity, maxHeight: 5, alignment: .trailing)
                
        }
        .padding()
        .frame(maxWidth: .infinity, minHeight: 75)
        .background(
            currency.flagImage
                .resizable()
                .scaledToFill()
                .opacity(0.40)
                .scaleEffect(1.1)
                .blur(radius: 15)
        )
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.black)
                .shadow(color: Color.black.opacity(1) ,radius:4)
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .strokeBorder(.gray.opacity(currency.border), lineWidth: 2)
                )
                .animation(.easeInOut(duration: 0.2), value: currency.border)
            )
        .sheet(isPresented: $isShowingNumberPad) {
            NumpadView(currency: currency, currencies: currencies)
                .presentationDetents([.height(225)])
        }
        .contentShape(Rectangle())
        .onTapGesture {
            isShowingNumberPad = true
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
