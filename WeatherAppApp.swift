//
//  WeatherAppApp.swift
//  WeatherApp
//
//  Created by chandana on 25/08/24.
//

import SwiftUI

@main
struct WeatherAppApp: App {
    
    @StateObject var weatherViewModel = WeatherViewModel()

    var body: some Scene {
        WindowGroup {
//            MainView()
            SearchView()
                .environmentObject(weatherViewModel)

        }
    }
}
