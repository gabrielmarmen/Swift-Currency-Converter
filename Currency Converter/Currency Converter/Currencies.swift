//
//  Currency.swift
//  Currency Converter
//
//  Created by Gabriel Marmen on 2022-10-05.
//

import Foundation
import SwiftUI
import FlagKit


class Currencies: ObservableObject {
    
    //Array with all available currencies
    @Published var all: [Currency]
    
    
    //Computed property that updates when a currency is enabled by the user
    var chosen: [Currency] {
        var tempArray = [Currency]()
        for currency in all {
            if currency.enabled{
                tempArray.append(currency)
            }
        }
        return tempArray
    }
    
    //Default Initializer
    init(){
        all = [Currency]()
    }
    
}

struct Currency: Codable, Identifiable {
    
    var code: String
    var name: String
    //The symbol for the currency might be needed in the future. From what I understand SwiftUI handles it nativelly though.
    
    var enabled = false
    var countries = [Country]()
    
    var id: String {
        code
    }
    
    //Using FlagKit to Generate a Flag SwiftUI Image.
    //This gets the first Country in the Countries List and returns its flag
    //If the currency is EUR it sends back the EU flag
    var flagImage: Image {
        guard code != "EUR" else {return Image(uiImage: Flag(countryCode: "EU")!.originalImage) }
        if let unWrappedcode = countries.first?.code {
            if let img = Flag(countryCode: unWrappedcode)?.originalImage {
                return Image(uiImage: img )
            }
        }
        return Image(systemName: "x.square.fill")
    }
    
    //Returns an exemple Currency of Afghanistan for testing purposes
    static func exempleCurrencyAfghanistan() -> Currency {
        var exempleCurrency = Currency(code: "AFN", name: "Afghani")
        let exempleCountry = Country(name: "Afghanistan", code: "AF")
        exempleCurrency.enabled = true
        
        exempleCurrency.countries.append(exempleCountry)
        
        return exempleCurrency
    }
    //Returns an exemple Currency of France for testing purposes
    static func exempleCurrencyFrance() -> Currency {
        var exempleCurrency = Currency(code: "EUR", name: "Euro")
        let exempleCountry = Country(name: "France", code: "FR")
        exempleCurrency.enabled = true
        
        exempleCurrency.countries.append(exempleCountry)
        
        return exempleCurrency
    }
    
}
