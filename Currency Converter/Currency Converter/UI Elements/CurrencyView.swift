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
    var currency: Currency
    
    
    
    
    var body: some View {
        HStack{
            VStack{
                flagImage
            }
            Spacer()
            VStack{
                
            }
        }
        
    }
}

struct CurrencyView_Previews: PreviewProvider {
    static var previews: some View {
        
        NavigationView{
            List{
                CurrencyView(currency: Currency.exempleCurrencyFrance())
            }
            
        }
    }
}
