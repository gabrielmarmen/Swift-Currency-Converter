// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let countries = try? newJSONDecoder().decode(Countries.self, from: jsonData)

import Foundation

// MARK: - Country
struct IntermediateCountry: Codable {
    let id: Int
    let name, isoAlpha2, isoAlpha3: String
    let isoNumeric: Int
    let currency: IntermediateCurrency
    let flag: String
}

// MARK: - Currency
struct IntermediateCurrency: Codable {
    let code, name: String
    let symbol: Symbol
}

enum Symbol: Codable {
    case bool(Bool)
    case string(String)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(Bool.self) {
            self = .bool(x)
            return
        }
        if let x = try? container.decode(String.self) {
            self = .string(x)
            return
        }
        throw DecodingError.typeMismatch(Symbol.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for Symbol"))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .bool(let x):
            try container.encode(x)
        case .string(let x):
            try container.encode(x)
        }
    }
    
    func get() -> String {
            switch self {
            case .string(let symbol):
                return symbol
            case .bool(_):
                return "There is no symbol"
            }
        }
}

typealias Countries = [IntermediateCountry]
