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
    
    
    var selectedCurrency: Currency {
        for currency in chosen {
            if currency.inputValue != nil {
                return currency
            }
        }
        return Currency(code: "EUR", name: "Undefined")
    }
    
    //Default Initializer
    init(){
        all = [Currency]()
    }
    
    
    
    func SetInputValue(selectedCurrency: Currency) {
        for currency in chosen where currency.inputValue != nil {
            currency.inputValue = nil
        }
        
        selectedCurrency.inputValue = selectedCurrency.calculatedValue
        
        
    }
}

class Currency: Identifiable, ObservableObject {
    
    var code: String
    var name: String
    //The symbol for the currency might be needed in the future. From what I understand SwiftUI handles it nativelly though.
    @Published var inputValue: Double?
    @Published var calculatedValue = 5.5 // Calculate this with the conversion rate if Input value is nil
    
    var enabled = false
    var countries = [Country]()
    
    
    init(code: String, name: String){
        self.code = code
        self.name = name
    }
    
    var id: String {
        code
    }
    
    var isSelected: Bool {
        if self.inputValue != nil {
            return true
        } else {
            return false
        }
        
    }
    
    //Returns the value in the right format for the currency used
    //Uses the input value if the currency is the one being edited if not uses the calculatedValue
    var formatedValue: String {
        if inputValue == nil {
            return calculatedValue.formatted(.currency(code: code))
        }
        else {
            return (inputValue ?? 0.0).formatted(.currency(code: code))
        }
    }
    
    //Using local assets to Generate a Flag SwiftUI Image.
    //This gets the first Country in the Countries List and returns its flag
    //If the currency is EUR it sends back the EU flag
    var flagImage: Image {
        guard code != "EUR" else {return Image("eu") }
        guard code != "GBP" else {return Image("gb") }
        if let unWrappedcode = countries.first?.code {
            return Image(unWrappedcode.lowercased())
        }
        return Image(systemName: "x.square.fill")
    }
    
    
    
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    //Returns an exemple Currency of Afghanistan for testing purposes
    static func exempleCurrencyAfghanistan() -> Currency {
        let exempleCurrency = Currency(code: "AFN", name: "Afghani")
        let exempleCountry = Country(name: "Afghanistan", code: "AF")
        exempleCurrency.enabled = true
        
        exempleCurrency.countries.append(exempleCountry)
        
        return exempleCurrency
    }
    //Returns an exemple Currency of France for testing purposes
    static func exempleCurrencyFrance() -> Currency {
        let exempleCurrency = Currency(code: "EUR", name: "Euro")
        let exempleCountry = Country(name: "France", code: "FR")
        exempleCurrency.enabled = true
        
        exempleCurrency.countries.append(exempleCountry)
        
        return exempleCurrency
    }
    
}
