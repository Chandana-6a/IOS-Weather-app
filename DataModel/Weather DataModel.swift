//
//  Weather DataModel.swift
//  WeatherApp
//
//  Created by chandana on 03/09/24.
//

import Foundation

struct LocationSuggestionsResponse: Decodable {
    let suggestions: [GeocodingResponse]
    
    
}
struct GeocodingResponse: Decodable {
    let name: String
    let country: String
    let state: String?
    let lat: Double
    let lon: Double
    let local_names: [String: String]?
}

// current weather response
struct WeatherResponse: Decodable {
    let main: WeatherMain
    let weather: [WeatherDetail]
    let wind: Wind
    let sys: Sys
    let timezone: Int
    
    struct WeatherMain: Decodable {
        let temp: Double
        let feels_like: Double
    }
    struct WeatherDetail: Decodable {
        let main: String
        let description: String
        let icon: String
    }
    
    struct Wind: Codable {
        let speed: Double
    }
    
    struct Sys: Codable {
        let sunrise: Double
        let sunset: Double
    }

}

// hourly weather response
struct HourlyResponse: Decodable {
    let list: [HourDetails]
    
    struct HourDetails: Decodable {
        let dt: Int              // timestamp
        let main: WeatherMain
        let weather: [HourWeatherDetail]
        let pop: Double           // probability of precipitation
    }

    struct WeatherMain: Decodable {
        let temp: Double
    }

    struct HourWeatherDetail: Decodable {
        let main: String
    //    let description: String
        let icon: String
        
    }
}

// daily weather response
struct DailyResponse: Decodable {
    let list: [DayDetails]
    
    struct DayDetails: Decodable {
        let dt: Int
        let temp: DayTemperature
        let weather: [DailyWeatherDetail]
        let pop: Double           // probability of precipitation
    }

    struct DayTemperature: Decodable {
        let min: Double
        let max: Double
    }
    struct DailyWeatherDetail: Decodable {
        let main: String
        let description: String
        let icon: String
    }
}

// 
struct OtherBasicInfoResponse: Decodable{
    let days: [WeatherDay]
    
    struct WeatherDay: Codable {
        let precipcover: Double
        let precipprob: Double
        let moonphase: Double
        let conditions: String
    }
}

//
struct OtherBasicInfoResponse2: Decodable{
    let data: [WeatherData]
    
    struct WeatherData: Codable {
        let aqi: Double
        let uv: Int
    }
}


