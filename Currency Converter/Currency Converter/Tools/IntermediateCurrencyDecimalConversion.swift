// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let intermediateCurrencyDecimalConversions = try? newJSONDecoder().decode(IntermediateCurrencyDecimalConversions.self, from: jsonData)

import Foundation

// MARK: - IntermediateCurrencyDecimalConversion
struct IntermediateCurrencyDecimalConversion: Codable {
    let code: String
    let decimals: Int?
    let name, number: String
}

typealias IntermediateCurrencyDecimalConversions = [IntermediateCurrencyDecimalConversion]
