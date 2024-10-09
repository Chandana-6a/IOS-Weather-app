//
//  WeatherURL+Extension.swift
//  Final Travel App
//
//  Created by chandana on 16/08/24.
//


import Foundation

extension URL {
    
    
    static func urlForLocationDetails(_ name: String) -> URL? {
        let apiKey = "Your_key"
        let urlString = "https://api.openweathermap.org/geo/1.0/direct?q=\(name)&limit=10&appid=\(apiKey)"
        return URL(string: urlString)
    }

    static func urlForCurrentWeather(lat: Double, lon: Double) -> URL? {
        let apiKey = "Your_key"
        let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=\(apiKey)&units=metric"
        return URL(string: urlString)
    }
    
    static func urlForHourlyForecast(lat: Double, lon: Double) -> URL? {
        let apiKey = "Your_key"
        let urlString = "https://pro.openweathermap.org/data/2.5/forecast/hourly?lat=\(lat)&lon=\(lon)&appid=\(apiKey)&units=metric&cnt=24"
        return URL(string: urlString)
    }
    
    static func urlForDailyForecast(lat: Double, lon: Double) -> URL? {
        let apiKey = "Your_key"
        let urlString = "https://api.openweathermap.org/data/2.5/forecast/daily?lat=\(lat)&lon=\(lon)&appid=\(apiKey)&units=metric&cnt=7"
        return URL(string: urlString)
    }
    
    static func urlForOtherBasicWeather(lat: Double, lon: Double) -> URL? {
        let apiKey = "Your_key"
        let urlString =
        "https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline/\(lat),\(lon)/today?include=current&unitGroup=metric&key=\(apiKey)&contentType=json"
        return URL(string: urlString)
    }

    static func urlForOtherBasicWeatherInfo2(lat: Double, lon: Double) -> URL? {
        let apiKey = "Your_key" 
        let urlString =
        "https://api.weatherbit.io/v2.0/current?lat=\(lat)&lon=\(lon)&key=\(apiKey)"
        return URL(string: urlString)
    }
}


extension String {
    func escaped() -> String? {
        let escapedString = self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        print("Original: \(self), Escaped: \(String(describing: escapedString))")
        return escapedString
    }
}

