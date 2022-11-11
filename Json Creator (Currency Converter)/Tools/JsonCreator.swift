//
//  JsonCreator.swift
//  Currency Converter
//
//  Temporary code to generate Custom Objects and json.
//  The generated json will be used on app lauch instead of processing everytime
//
//  Created by Gabriel Marmen on 2022-11-08.
//

import Foundation
import UIKit

struct JsonCreator {
    
   
    
    
    static func getCurrencyArray() -> [Currency]{
        let intermediateCountriesList = getIntermediateCountries()
        let intermediateCurrencyDecimalConversions = getCurrencyDecimalConversion()
        return convertToCustomCurrencyArray(countries: intermediateCountriesList, decimalConversionTable: intermediateCurrencyDecimalConversions)
    }
    
    static func convertToCustomCurrencyArray(countries: [IntermediateCountry], decimalConversionTable: [IntermediateCurrencyDecimalConversion]) -> [Currency]{
        
        var customCurrencyArray = [Currency]()
        let exempleExchangeRate = ExchangeRate.exempleExchangeRate
        var tempExchangeRate = ExchangeRate.exempleExchangeRate.conversionRates
        for intermediateCountry in countries {
            var tempCurrencySymbol: String
            if intermediateCountry.currency.symbol.get() != "There is no symbol" {
                tempCurrencySymbol = intermediateCountry.currency.symbol.get()
            }
            else {
                tempCurrencySymbol = intermediateCountry.currency.code
            }
            
            let tempCountry = Country(name: intermediateCountry.name, code: intermediateCountry.isoAlpha2)
            let tempCurrency = Currency(code: intermediateCountry.currency.code, name: getFullName(in: decimalConversionTable, for: intermediateCountry.currency), symbol: tempCurrencySymbol, maxDecimal: getMaxDecimal(in: decimalConversionTable, for: intermediateCountry.currency.code))
            
            if !customCurrencyArray.contains(tempCurrency) {
                if exempleExchangeRate.conversionRates[tempCurrency.code] != nil {
                    tempCurrency.countries.append(tempCountry)
                    customCurrencyArray.append(tempCurrency)
                }
                else {
                    print("Could not find " + tempCurrency.code)
                }
            }
            else{
                customCurrencyArray[customCurrencyArray.firstIndex(of: tempCurrency)!].countries.append(tempCountry)
            }
            
            //Diagnostics for the currencies that are not found inside the coutries.json file
            
            for currency in customCurrencyArray {
                if exempleExchangeRate.conversionRates[currency.code] != nil{
                    tempExchangeRate.removeValue(forKey: currency.code)
                }
            }
            
            
            
        }
        print("There are " + String(customCurrencyArray.count) + " currencies inside the array after corrections")
        saveToLocalFiles(currencies: customCurrencyArray)
        return customCurrencyArray
    }
    
    static func saveToLocalFiles(currencies: [Currency]) {
        let JSONEncoderInstance = JSONEncoder()
        let jsonData = try? JSONEncoderInstance.encode(currencies)
        
        
       
            let pathWithFilename = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("CurrenciesArray.json")
            do {
                try String(data: jsonData!, encoding: .utf8)?.write(to: pathWithFilename!, atomically: true, encoding: .utf8)
            } catch {
               print("SHEESH")
            }
        var filesToShare = [Any]()
        filesToShare.append(pathWithFilename!)
        let av = UIActivityViewController(activityItems: filesToShare, applicationActivities: nil)
        UIApplication.shared.windows.first?.rootViewController?.present(av, animated: true, completion: nil)
        
    }
    
    static func getMaxDecimal(in conversionTable: [IntermediateCurrencyDecimalConversion], for code: String) -> Int{
        let conversionEntry = conversionTable.first(where: {$0.code == code})
        return conversionEntry?.decimals ?? 2
    }
    
    static func getFullName(in conversionTable: [IntermediateCurrencyDecimalConversion], for currency: IntermediateCurrency) -> String{
        let conversionEntry = conversionTable.first(where: {$0.code == currency.code})
        return conversionEntry?.name ?? currency.name
    }
    
    static func getIntermediateCountries() -> [IntermediateCountry] {
        let JSONDecoderInstance = JSONDecoder()
        if let intermediateCountries = try? JSONDecoderInstance.decode([IntermediateCountry].self, from: getDataFromFile(name: "countries")!){
            print("Loaded IntermediateCountry array from local file (countries.json)")
            print("There are " + String(intermediateCountries.count) + " countries inside the array")
            return intermediateCountries
        }
        return [IntermediateCountry]()
        
    }
    static func getCurrencyDecimalConversion() -> [IntermediateCurrencyDecimalConversion] {
        let JSONDecoderInstance = JSONDecoder()
        if let intermediateCurrencyDecimalConversions = try? JSONDecoderInstance.decode([IntermediateCurrencyDecimalConversion].self, from: getDataFromFile(name: "decimalCurrencyConversion")!){
            print("Loaded IntermediateCurrencyDecimalConversion array from local file (decimalCurrencyConversion.json)")
            print("There are " + String(intermediateCurrencyDecimalConversions.count) + " currencies inside the array")
            return intermediateCurrencyDecimalConversions
        }
        return [IntermediateCurrencyDecimalConversion]()
    }
    
    static func getDataFromFile(name: String) -> Data? {
        do {
            if let bundlePath = Bundle.main.path(forResource: name, ofType: "json"),
                let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
                return jsonData
            }
        } catch {
            print(error)
        }
        
        return nil
    }
}
