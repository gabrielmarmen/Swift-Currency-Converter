//
//  AddView.swift
//  Currency Converter
//
//  Created by Gabriel Marmen on 2022-11-09.
//

import SwiftUI

struct AddView: View {
    
    @ObservedObject var currencies: Currencies
    
    @State private var searchString: String = ""
    
    
    var searchResults: [Currency] {
        if searchString == "" {
            return currencies.all
        }
        else{
            var filteredCurrencies = [Currency]()
            for currency in currencies.all {
                if currency.name.range(of: searchString, options: .caseInsensitive) != nil {
                    filteredCurrencies.append(currency)
                    continue
                }
                else if currency.code.range(of: searchString, options: .caseInsensitive) != nil
                {
                    filteredCurrencies.append(currency)
                    continue
                }
                for country in currency.countries {
                    if country.name.range(of: searchString, options: .caseInsensitive) != nil  {
                        filteredCurrencies.append(currency)
                        break
                    }
                }
            }
            return filteredCurrencies
        }
    }
    
    
    var body: some View {
        NavigationView{
                List{
                    if !currencies.chosen.isEmpty && searchString == ""{
                        Section{
                            ForEach(currencies.all){ currency in
                                if currency.enabled {
                                    HStack{
                                        currency.flagImage
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 60, height: 40)
                                            .clipShape(RoundedRectangle(cornerRadius: 7))
                                        Text(currency.name)
                                            .font(.headline)
                                        Spacer()
                                        Image(systemName: currency.enabled ? "checkmark.circle.fill" : "circle")
                                            .foregroundColor(currency.enabled ? Color(UIColor.systemBlue) : Color.secondary)
                                    }
                                    .contentShape(Rectangle())
                                    .onTapGesture {
                                        withAnimation{
                                            currencies.objectWillChange.send()
                                            currency.enabled.toggle()
                                            
                                        }
                                    }
                                }
                            }
                        }header: {
                            Text("Selected Currencies")
                        }
                    }
                    Section{
                        ForEach(searchResults){ currency in
                            HStack{
                                currency.flagImage
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 60, height: 40)
                                    .clipShape(RoundedRectangle(cornerRadius: 7))
                                
                                Text(currency.name)
                                    .font(currency.enabled ? .headline : .body)
                                    .foregroundColor(currency.enabled ? .primary : .secondary)
                                    .animation(.linear.speed(5), value: currency.enabled)
                                Spacer()
                                Image(systemName: currency.enabled ? "checkmark.circle.fill" : "circle")
                                    .foregroundColor(currency.enabled ? Color(UIColor.systemBlue) : Color.secondary)
                                    
                            }
                            .contentShape(Rectangle())
                            .onTapGesture {
                                withAnimation{
                                    currencies.objectWillChange.send()
                                    currency.enabled.toggle()
                                }
                            }
                            
                        }
                    }header: {
                        Text(searchString == "" ? "All Currencies" : "Search Results")
                    }
                    
                }
                .searchable(text: $searchString, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search by currency name, code or country")
                .listStyle(.plain)
                .navigationTitle("Add Currencies")
                .navigationBarTitleDisplayMode(.inline)
                .animation(.easeInOut, value: searchResults)
        }
        .onChange(of: currencies.chosen) { _ in
            
            currencies.CalculateConversions()
        }
        
    }
}
struct AddView_Previews: PreviewProvider {
    static var allCurrencies = Currencies()
    static var previews: some View {
        
        AddView(currencies: allCurrencies)
            .onAppear {
                allCurrencies.all.append(Currency.exempleCurrencyAfghanistan())
                allCurrencies.all.append(Currency.exempleCurrencyFrance())
            }
    }
}
