//
//  UpdateStatus.swift
//  Currency Converter
//
//  Created by Gabriel Marmen on 2022-12-15.
//

import SwiftUI

struct UpdateStatus: View {
    
    @Binding var currentExchangeRate: ExchangeRate
    @Binding var loadingState: LoadingState
    
    var body: some View {
        HStack(alignment: .center){
            if loadingState == .loading {
                ProgressView()
                    .padding(.horizontal, 1)
                    .scaleEffect(0.90)
            } else {
                
                loadingState == .failedLoading ?
                Image(systemName: "x.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 15)
                    .frame(width: 20)
                    .foregroundColor(.red)
                    .opacity(0.5)
                    .padding(.horizontal, 1)
                    
                :
                Image(systemName: "checkmark.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 15)
                    .frame(width: 20)
                    .foregroundColor(.green)
                    .opacity(0.5)
                    .padding(.horizontal, 1)
                    
            }
            
            VStack{
                
                Text("Last successful refresh : \(currentExchangeRate.refreshedAt.formatted())")
                    .foregroundColor(.gray)
                    .font(.system(size: 10))
                
                
                
                Text("Rates (Delayed up to 5 min.) : \(Date(timeIntervalSince1970: currentExchangeRate.timestamp).formatted())")
                    .foregroundColor(.gray)
                    .font(.system(size: 10))
                
            }
            
        }
        .frame(width: 500)
        
    }
}

//struct UpdateStatus_Previews: PreviewProvider {
//
//    static var previews: some View {
//        UpdateStatus()
//    }
//}

