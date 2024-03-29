//
//  ExchangeRate.swift
//  Currency Converter
//
//  Created by Gabriel Marmen on 2022-11-25.
//

import Foundation

class ExchangeRate: Codable, Identifiable, ObservableObject, Comparable {
    static func == (lhs: ExchangeRate, rhs: ExchangeRate) -> Bool {
        lhs.timestamp == rhs.timestamp
    }
    
    static func < (lhs: ExchangeRate, rhs: ExchangeRate) -> Bool {
        lhs.timestamp < rhs.timestamp
    }
    
    
    //Indicated the current loading status (Loaded, Failed loading, loading)
    
    
    var id: UUID?
    var timestamp: Double
    var refreshedAt: Date
    var conversionRates: [String: Double]
    
    
    
    enum CodingKeys: String, CodingKey {
        case id
        case timestamp
        case refreshedAt
        case conversionRates = "rates"
    }
    
    init() {
        if let cachedExchangeRate = ExchangeRate.getCachedExchangeRate() {
            self.conversionRates = cachedExchangeRate.conversionRates
            self.timestamp = cachedExchangeRate.timestamp
            self.refreshedAt = cachedExchangeRate.refreshedAt
        } else {
            let exExchangeRate = ExchangeRate.exempleExchangeRate
            self.conversionRates = exExchangeRate.conversionRates
            self.timestamp = exExchangeRate.timestamp
            self.refreshedAt = Date(timeIntervalSince1970: exExchangeRate.timestamp)
        }
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        timestamp = try container.decode(Double.self, forKey: .timestamp)
        refreshedAt = try container.decodeIfPresent(Date.self, forKey: .refreshedAt) ?? Date()
        conversionRates = try container.decode([String: Double].self, forKey: .conversionRates)
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
    func saveToUserDefault() {
        guard let encodedExchangeRate = try? JSONEncoder().encode(self) else {
            print("Failed to encode Exchange Rate")
            return
        }
        UserDefaults.standard.set(encodedExchangeRate, forKey: "cachedExchangeRate")
        print("Saved exchangeRates to UserDefaults")
    }
    
    //Loads the cached ExchangeRate. If it doesnt exist, it returns an exemple Exchange Rate
    static func getCachedExchangeRate() -> ExchangeRate? {
        if let data = UserDefaults.standard.data(forKey: "cachedExchangeRate") {
            if let decodedData = try? JSONDecoder().decode(ExchangeRate.self, from: data) {
                print("Loaded cached exchange rates.")
                return decodedData
            }
        }
        return nil
    }
    //Gets the latest exchange rate from the API
    static func getLatestExchangeRate() async -> ExchangeRate? {
        
        do {
            let session = URLSession.shared
            session.configuration.timeoutIntervalForResource = 10
            let (data,_) = try await session.data(from: API.latestURL)
            if let decodedData = try? JSONDecoder().decode([ExchangeRate].self, from: data){
                let latestExchangeRate = decodedData.sorted().last
                latestExchangeRate?.refreshedAt = Date.now
                print("Got latest Exchange Rates from API.")
                return latestExchangeRate
            }
            else{
                return nil
            }
        }
        catch {
            print(error)
            return nil
        }

    }
}
