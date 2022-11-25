//
//  ExchangeRate.swift
//  Currency Converter
//
//  Created by Gabriel Marmen on 2022-11-25.
//

import Foundation

class ExchangeRate: Codable, Identifiable {
    
    var id: UUID?
    var timestamp: Double
    var conversionRates: [String: Double]
    
    enum CodingKeys: String, CodingKey {
        case id
        case timestamp 
        case conversionRates = "rates"
    }
    
    init() {
        if let cachedExchangeRate = ExchangeRate.getCachedExchangeRate() {
            self.conversionRates = cachedExchangeRate.conversionRates
            self.timestamp = cachedExchangeRate.timestamp
        }else{
            let exExchangeRate = ExchangeRate.exempleExchangeRate
            self.conversionRates = exExchangeRate.conversionRates
            self.timestamp = exExchangeRate.timestamp
        }
    }
    
    static var exempleExchangeRate: ExchangeRate {
        let url = Bundle.main.path(forResource: "SampleExchangeRateToUSD", ofType: "json")
        let data = try? String(contentsOfFile: url!).data(using: .utf8)
        let exchangeRates = try? JSONDecoder().decode([ExchangeRate].self, from: data!)
        
        if exchangeRates != nil {
            print("Loaded exemple exchange rates.")
        }
        else {
            print("There was an error loading the exemple exchange rates")
        }
        
        return exchangeRates!.first!
    }
    
    //Loads the cached ExchangeRate. If it doesnt exist, it returns an exemple Exchange Rate
    static func getCachedExchangeRate() -> ExchangeRate? {
        if let data = UserDefaults.standard.data(forKey: "cachedExchangeRate") {
            return try? JSONDecoder().decode([ExchangeRate].self, from: data).first
        }
        return nil
    }
    //Gets the latest exchange rate from the API
    static func getLatestExchangeRate() -> ExchangeRate {
        //Temporary return
        return ExchangeRate.exempleExchangeRate
    }
}
