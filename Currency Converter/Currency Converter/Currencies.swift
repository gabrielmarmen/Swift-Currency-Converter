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
    
    
    //This returns the currently selected currency (One being modified)
    //Loop through the currencies to see which one has a non nil input.
    //Every currencies is supposed to have a nil value except the one that is currenctly selected to be converted
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
        
        if let array = try? JSONDecoder().decode([Currency].self, from: Bundle.getDataFromFile(name: "CurrenciesArray")!) {
            for currency in array {
                currency.ConfigureNumberFormatter()
            }
            all = array
        }
        else {
            all = [Currency]()
        }
        
    }
    
    //Calculates all the conversions from the chosen currency. Executes everytime one of the chosen currency's inputValue changes.
    func CalculateConversions() {
        for currency in chosen {
            if currency.inputValue != nil {
                currency.calculatedValue = currency.inputValue!
                
            }else {
                if let selectedCurrencyConversionRate = conversionRates[selectedCurrency.code]{
                    if let conversionRate = conversionRates[currency.code]{
                        if let inputValue = selectedCurrency.inputValue{
                            currency.calculatedValue = inputValue / selectedCurrencyConversionRate * conversionRate
                        }
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

class Currency: Identifiable, ObservableObject, Equatable, Codable {
    
    
    @Published var inputValue: Double?
    @Published var calculatedValue: Double? = 0.0
    @Published var enabled: Bool = false
    
    var code: String
    var name: String
    var symbol: String
    var maxDecimal: Int
    
    
    var countries = [Country]()
    //Creates a default numberFormatter.
    //It is configured using the ConfigureNumberFormatter function to be formatting correctly with the type of currency
    var numberFormatter = NumberFormatter()
    
    
    enum CodingKeys: CodingKey {
        case inputValue
        case enabled
        
        case code
        case name
        case symbol
        case maxDecimal
        case countries
    }
    
    init(code: String, name: String, symbol: String, maxDecimal: Int){
        self.code = code
        self.name = name
        self.symbol = symbol
        self.maxDecimal = maxDecimal
        ConfigureNumberFormatter()
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        inputValue = try container.decode(Double?.self, forKey: .inputValue)
        enabled = try container.decode(Bool.self, forKey: .enabled)
        
        code = try container.decode(String.self, forKey: .code)
        name = try container.decode(String.self, forKey: .name)
        symbol = try container.decode(String.self, forKey: .symbol)
        maxDecimal = try container.decode(Int.self, forKey: .maxDecimal)
        countries = try container.decode([Country].self, forKey: .countries)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(inputValue, forKey: .inputValue)
        try container.encode(enabled, forKey: .enabled)
        
        try container.encode(code, forKey: .code)
        try container.encode(name, forKey: .name)
        try container.encode(symbol, forKey: .symbol)
        try container.encode(maxDecimal, forKey: .maxDecimal)
        try container.encode(countries, forKey: .countries)
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
        guard code != "USD" else {return Image("us") }
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
    
    func disable() {
        self.enabled = false
    }
    
    static func == (lhs: Currency, rhs: Currency) -> Bool {
        if lhs.code == rhs.code {return true}
        else {return false}
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
