//
//  API.swift
//  Currency Converter
//
//  Created by Gabriel Marmen on 2022-11-26.
//

import Foundation

final class API {
    
    static let baseURL = URL(string: "https://currencyconverter.gabrielmarmen.com")!
    
    static var latestURL: URL {
        API.baseURL.appendingPathComponent("/exchange-rates/latest")
    }
    
    init(){
    }
    
    
}
