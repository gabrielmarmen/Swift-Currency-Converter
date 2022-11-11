//
//  Extensions.swift
//  Currency Converter
//
//  Created by Gabriel Marmen on 2022-11-11.
//

import Foundation

extension Bundle {
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
