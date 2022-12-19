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

    
    private var title: String {
        
        switch loadingState {
        case .loading:
            return "Refreshing"
            
        case .failedLoading:
            return ""
            
        case .loaded:
            return ""
        }
       
    }
    private var text: String {
        
        switch loadingState {
        case .loading:
            return ""
            
        case .failedLoading:
            return "An error occured. Please try again later."
            
        case .loaded:
            return "Last successful refresh : \(Date.now.formatted())"
        }
       
    }
    private var text2: String {
        
        switch loadingState {
        case .loading:
            return "Please wait"
            
        case .failedLoading:
            return "Last pulled exchange rates : \(Date(timeIntervalSince1970: currentExchangeRate.timestamp).formatted())"
            
        case .loaded:
            return "Latest available rates : \(Date(timeIntervalSince1970: currentExchangeRate.timestamp).formatted())"
        }
       
    }
    
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
                    .foregroundColor(.red)
                    .opacity(0.5)
                    .padding(.horizontal, 1)
                    
                :
                Image(systemName: "checkmark.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 15)
                    .foregroundColor(.green)
                    .opacity(0.5)
                    .padding(.horizontal, 1)
                    
            }
            
            VStack{
                if title != "" {
                    Text(title)
                        .foregroundColor(.gray)
                        .font(.system(size: 15))
                }
                if text != "" {
                    Text(text)
                        .foregroundColor(.gray)
                        .font(.system(size: 10))
                }
                
                if text2 != "" {
                    Text(text2)
                        .foregroundColor(.gray)
                        .font(.system(size: 10))
                }
            }
            
        }
        
    }
}

//struct UpdateStatus_Previews: PreviewProvider {
//
//    static var previews: some View {
//        UpdateStatus()
//    }
//}

