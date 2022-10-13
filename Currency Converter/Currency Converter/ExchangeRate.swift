// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let exchangeRateToUSD = try? newJSONDecoder().decode(ExchangeRateToUSD.self, from: jsonData)

import Foundation

// MARK: - ExchangeRateToUSD
class ExchangeRateToUSD: Codable {
    let result: String
    let documentation, termsOfUse: String
    let timeLastUpdateUnix: Int
    let timeLastUpdateUTC: String
    let timeNextUpdateUnix: Int
    let timeNextUpdateUTC, baseCode: String
    let conversionRates: [String: Double]

    enum CodingKeys: String, CodingKey {
        case result, documentation
        case termsOfUse = "terms_of_use"
        case timeLastUpdateUnix = "time_last_update_unix"
        case timeLastUpdateUTC = "time_last_update_utc"
        case timeNextUpdateUnix = "time_next_update_unix"
        case timeNextUpdateUTC = "time_next_update_utc"
        case baseCode = "base_code"
        case conversionRates = "conversion_rates"
    }

    init(result: String, documentation: String, termsOfUse: String, timeLastUpdateUnix: Int, timeLastUpdateUTC: String, timeNextUpdateUnix: Int, timeNextUpdateUTC: String, baseCode: String, conversionRates: [String: Double]) {
        self.result = result
        self.documentation = documentation
        self.termsOfUse = termsOfUse
        self.timeLastUpdateUnix = timeLastUpdateUnix
        self.timeLastUpdateUTC = timeLastUpdateUTC
        self.timeNextUpdateUnix = timeNextUpdateUnix
        self.timeNextUpdateUTC = timeNextUpdateUTC
        self.baseCode = baseCode
        self.conversionRates = conversionRates
    }
}
