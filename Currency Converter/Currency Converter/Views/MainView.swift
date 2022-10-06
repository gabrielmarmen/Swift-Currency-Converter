//
//  MainView.swift
//  Currency Converter
//
//  Created by Gabriel Marmen on 2022-10-05.
//

import SwiftUI

struct MainView: View {
    
    
    
    
    var body: some View {
        TabView{
            ContentView()
                .tabItem{
                    Label("Currencies", systemImage: "dollarsign.circle" )
                }
            SettingsView()
                .tabItem{
                    Label("Settings", systemImage: "gearshape.circle" )
                }
        }
        
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
