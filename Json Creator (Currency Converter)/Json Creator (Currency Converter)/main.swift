//
//  main.swift
//  Json Creator (Currency Converter)
//
//  Created by Gabriel Marmen on 2022-10-07.
//

import Foundation

let newJSONDecoder = JSONDecoder()
let data = Data()
let jsonCreator = JsonCre
let intermediateCountries = try? newJSONDecoder.decode(Countries.self, from: readLocalFile(forName: "countries")!)


struct JsonCreator {
    
    
    
    func readLocalFile(forName name: String) -> Data? {
        do {
            if let bundlePath = Bundle.main.path(forResource: name, ofType: "json"),
                let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
                print("Loaded countries data")
                return jsonData
            }
        } catch {
            print(error)
        }
        
        return nil
    }
}









