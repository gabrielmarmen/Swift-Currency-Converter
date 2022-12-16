//
//  Settings.swift
//  Currency Converter
//
//  Created by Gabriel Marmen on 2022-11-25.
//

import Foundation
import SwiftUI

class Settings: ObservableObject{
    
    @Published var darkModeOn = true
    @Published var bankFeesEnabled = false
    
    
    var backgroundColor = Color(hex: 0x141414)
    
}
