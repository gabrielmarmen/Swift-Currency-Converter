//
//  MainView.swift
//  Currency Converter
//
//  Created by Gabriel Marmen on 2022-10-05.
//

import SwiftUI



struct MainView: View {
    
    
    @StateObject var settings = Settings()
    
    
    var body: some View {
        ZStack {
            settings.backgroundColor
            TabView{
                ContentView()
                    .tabItem{
                        Label("Currencies", systemImage: "dollarsign.circle" )
                    }
                    .preferredColorScheme(settings.darkModeOn ? .dark : .light)
                    .environmentObject(settings)
                SettingsView()
                    .tabItem{
                        Label("Settings", systemImage: "gearshape.circle" )
                    }
                    .preferredColorScheme(settings.darkModeOn ? .dark : .light)
                    .environmentObject(settings)
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
