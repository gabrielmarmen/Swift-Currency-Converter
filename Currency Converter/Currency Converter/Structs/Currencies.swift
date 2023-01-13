//
//  Currency.swift
//  Currency Converter
//
//  Created by Gabriel Marmen on 2022-10-05.
//

import Foundation
import SwiftUI


class Currencies: ObservableObject {
    
    //Array with all available currencies
    @Published var all: [Currency]
    @Published var currentExchangeRate  = ExchangeRate()
    
    

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
    //InitialiseExchangeRate
    //Getting cachedCurrencyArray or pulling it from the Bundle depending if it already exists
    //Configuring the NumberFormatter for every currencies
    init(){
       
        var array = [Currency]()
        //Verifies if there is a cached cachedCurrencyArray, if it doesnt exist it gets the Bundle clean version.
        if let tempArray = Currency.getCachedCurrencies() {
            array = tempArray
        } else {
            array = try! JSONDecoder().decode([Currency].self, from: Bundle.getDataFromFile(name: "CurrenciesArray")!)
        }
        
        
        //Configures the number formatter for each and every currencies.
        for currency in array {
            currency.ConfigureNumberFormatter()
        }
        //Sets the array for usage in app
        all = array
        print(all.count)
        CalculateConversions()
    }
    
    //Calculates all the conversions from the chosen currency. Executes everytime one of the chosen currency's inputValue changes.
    func CalculateConversions() {
        for currency in chosen {
            if currency.inputValue != nil {
                withAnimation(.easeInOut.speed(3)){
                    currency.calculatedValue = currency.inputValue!
                    
                }
            } else {
                if let selectedCurrencyConversionRate = currentExchangeRate.conversionRates[selectedCurrency.code]{
                    if let conversionRate = currentExchangeRate.conversionRates[currency.code]{
                        if let inputValue = selectedCurrency.inputValue{
                            withAnimation(.linear.speed(3)){
                                currency.calculatedValue = inputValue / selectedCurrencyConversionRate * conversionRate
                            }
                        }
                    }
                    else {
                        print("Failed to find conversion rate for \(currency.code) in ExchangeRate.")
                        currency.calculatedValue = nil
                    }
                }else {
                    print("Failed to find conversion rate for \(selectedCurrency.code) in ExchangeRate.")
                    currency.calculatedValue = nil
                }
            }
        }
        print("Calculated Conversions")
    }
    
    
    
    func updateExchangeRateWithLatest() async {
        if let updatedExcangeRate = await ExchangeRate.getLatestExchangeRate() {
            self.currentExchangeRate = updatedExcangeRate
            self.currentExchangeRate.saveToUserDefault()
            CalculateConversions()
        } else {
            print("Failed to get latest ExchangeRate")
        }
        
    }
    
    func updateExchangeRate(with updatedExchangeRate: ExchangeRate) {
        self.currentExchangeRate = updatedExchangeRate
        self.currentExchangeRate.saveToUserDefault()
        CalculateConversions()
    }
    
    //This function resets the input values to nil and set the newly selected Currency's input value to the same as the calculated one
    //It is called in the CurrencyView when a currency is tapped.
    func SetAsSelected(selectedCurrency: Currency) {
        for currency in chosen where currency.inputValue != nil {
            currency.setInputValue(with: nil, currencies: self)
            
        }
        selectedCurrency.setInputValue(with: selectedCurrency.calculatedValue, currencies: self)
       
        
        print(selectedCurrency.code + " was selected")
    }
    
    func saveCurrencyArrayToUserDefault() {
        guard let encodedExchangeRate = try? JSONEncoder().encode(self.all) else {
            print("Failed to encode Exchange Rate")
            return
        }
        UserDefaults.standard.set(encodedExchangeRate, forKey: "cachedCurrencyArray")
    }
    
    func deleteCurrencyArrayUserDefault() {
        UserDefaults.standard.removeObject(forKey: "cachedCurrencyArray")
    }
    
}

class Currency: Identifiable, ObservableObject, Equatable, Codable {
    
    
    @Published private(set) var inputValue: Double?
    @Published private(set) var enabled: Bool = false
    @Published var calculatedValue: Double? = 0.0
    
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

    var border: Double {
        if self.isSelected {
            return 0.8
        } else {
            return 0.0
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
    
    //Equatable conformance
    static func == (lhs: Currency, rhs: Currency) -> Bool {
        if lhs.code == rhs.code {return true}
        else {return false}
    }
    
    //This function configures the number formatter so it is set up correctly for the type of currency (ex: EUR)
    func ConfigureNumberFormatter() {
        numberFormatter.numberStyle = .currency
        numberFormatter.currencySymbol = self.symbol
        numberFormatter.maximumFractionDigits = maxDecimal
    }
    
    func disable(currencies: Currencies) {
        currencies.objectWillChange.send()
        self.enabled = false
        if self.isSelected && currencies.chosen.count >= 1 {
            currencies.SetAsSelected(selectedCurrency: currencies.chosen.first!)
        }
        self.inputValue = nil
        currencies.saveCurrencyArrayToUserDefault()
    }
    func enable(currencies: Currencies) {
        currencies.objectWillChange.send()
        self.enabled = true
        if currencies.chosen.count == 1 {
            currencies.SetAsSelected(selectedCurrency: self)
        }
        currencies.saveCurrencyArrayToUserDefault()
    }
    
    func toggleEnabled(currencies: Currencies)  {
        currencies.objectWillChange.send()
        self.enabled.toggle()
        if self.enabled {
            if currencies.chosen.count == 1 {
                currencies.SetAsSelected(selectedCurrency: self)
                self.inputValue = 0.0
            }
        } else {
            if self.isSelected && currencies.chosen.count >= 1 {
                currencies.SetAsSelected(selectedCurrency: currencies.chosen.first!)
            }
            self.inputValue = nil
        }
        currencies.saveCurrencyArrayToUserDefault()
    }
    
    func setInputValue(with value: Double?, currencies: Currencies) {
        
        currencies.objectWillChange.send()
        self.inputValue = value
        currencies.saveCurrencyArrayToUserDefault()
    }
    

    static func getCachedCurrencies() -> [Currency]? {
        if let data = UserDefaults.standard.data(forKey: "cachedCurrencyArray") {
            return try? JSONDecoder().decode([Currency].self, from: data)
        } else{
            return nil
        }
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
        exempleCurrency.calculatedValue = 999_999_999_999.00
        exempleCurrency.enabled = true
        
        exempleCurrency.countries.append(exempleCountry)
        
        return exempleCurrency
    }
    
}
