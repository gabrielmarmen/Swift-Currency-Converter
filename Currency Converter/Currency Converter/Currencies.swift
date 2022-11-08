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
    //Conversion rates for the conversions. For now it is using a sample file for testing purposes. Later its going to be downloading the json from the web.
    var conversionRates = ExchangeRate.exempleExchangeRate.conversionRates

    //Chosen currencies that appear in the main View
    var chosen: [Currency] {
        var tempArray = [Currency]()
        for currency in all {
            if currency.enabled{
                tempArray.append(currency)
            }
        }
        return tempArray
    }
    
    
    //Returns the selected currency. If it fails it will return an undefined currency.
    var selectedCurrency: Currency {
        for currency in chosen {
            if currency.isSelected {
                return currency
            }
        }
        return Currency.exempleCurrencyFrance()
    }
    


    
    //Default Initializer
    //Creating an empty array of currency and configuring the NumberFormatter
    init(){
        all = [Currency]()
    }
    
    //Calculates all the conversions from the chosen currency. Executes everytime one of the chosen currency's inputValue changes.
    func CalculateConversions() {
        for currency in chosen {
            if currency.inputValue != nil {
                currency.calculatedValue = currency.inputValue!
                
            }else {
                if let selectedCurrencyConversionRate = conversionRates[selectedCurrency.code]{
                    if let conversionRate = conversionRates[currency.code]{
                        currency.calculatedValue = selectedCurrency.inputValue! / selectedCurrencyConversionRate * conversionRate
                    }
                    else {
                        print("Failed to find conversion rate.")
                        currency.calculatedValue = nil
                    }
                }else {
                    print("Failed to find conversion rate.")
                    currency.calculatedValue = nil
                }
                
                
            }
        }
        print("Calculated Conversions")
    }
    
    //This function resets the input values to nil and set the newly selected Currency's input value to the same as the calculated one
    //It is called in the CurrencyView when a currency is tapped.
    func SetAsSelected(selectedCurrency: Currency) {
        for currency in chosen where currency.inputValue != nil {
            currency.inputValue = nil
        }
        selectedCurrency.inputValue = 0.0
        print(selectedCurrency.code + " was selected")
    }
    

}

class Currency: Identifiable, ObservableObject, Equatable {
    static func == (lhs: Currency, rhs: Currency) -> Bool {
        if lhs.code == rhs.code {return true}
        else {return false}
        
    }
    
    
    var code: String
    var name: String
    var symbol: String
    var maxDecimal: Int
    @Published var inputValue: Double?
    @Published var calculatedValue: Double? = 0.0
    
    var enabled = false
    var countries = [Country]()
    //Creates a default numberFormatter.
    //It is configured using the ConfigureNumberFormatter function to be formatting correctly with the type of currency
    var numberFormatter = NumberFormatter()
    
    
    
    
    init(code: String, name: String, symbol: String, maxDecimal: Int){
        self.code = code
        self.name = name
        self.symbol = symbol
        self.maxDecimal = maxDecimal
        ConfigureNumberFormatter()
    }
    
    var id: String {
        code
    }
    
    var isSelected: Bool {
        if self.inputValue != nil {
            return true
        }
        else {
            return false
        }
    }
    
    //Returns the value in the right format taking into account the currency Used
    var formatedValue: String {
        
        if calculatedValue == nil {return "N/D"}
        else {return numberFormatter.string(from: NSNumber(value: calculatedValue!)) ?? "Error"}
        
            
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
    
    //This function configures the number formatter so it is set up correctly for the type of currency (ex: EUR)
    func ConfigureNumberFormatter() {
        numberFormatter.numberStyle = .currency
        numberFormatter.currencySymbol = self.symbol
        numberFormatter.maximumFractionDigits = maxDecimal
    }
    
    
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    //Returns an exemple Currency of Afghanistan for testing purposes
    static func exempleCurrencyAfghanistan() -> Currency {
        let exempleCurrency = Currency(code: "AFN", name: "Afghani", symbol: "؋", maxDecimal: 0)
        let exempleCountry = Country(name: "Afghanistan", code: "AF")
        exempleCurrency.enabled = true
        
        exempleCurrency.countries.append(exempleCountry)
        
        return exempleCurrency
    }
    //Returns an exemple Currency of France for testing purposes
    static func exempleCurrencyFrance() -> Currency {
        let exempleCurrency = Currency(code: "EUR", name: "Euro", symbol: "€", maxDecimal: 2)
        let exempleCountry = Country(name: "France", code: "FR")
        exempleCurrency.enabled = true
        
        exempleCurrency.countries.append(exempleCountry)
        
        return exempleCurrency
    }
    
}
