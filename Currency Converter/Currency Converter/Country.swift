//
//  Country.swift
//  Currency Converter
//
//  Created by Gabriel Marmen on 2022-10-05.
//

import Foundation

struct Country: Codable, Identifiable {
    var name: String
    var code: String
    
    var id: String {
        name
    }
}
