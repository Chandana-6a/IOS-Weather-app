//
//  WeatherService.swift
//  Final Travel App
//
//  Created by chandana on 16/08/24.
//

import Foundation

class WeatherService {
    
    // Get location details using the Geocoding API
    func getLocationDetails(name: String, completion: @escaping (GeocodingResponse?) -> Void) {
        guard let url = URL.urlForLocationDetails(name) else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            
            let geocodingResponse = try? JSONDecoder().decode([GeocodingResponse].self, from: data).first
            completion(geocodingResponse)
        }.resume()
    }
    
    //gets location suggestions
    func getLocationSuggestions(name: String, completion: @escaping ([GeocodingResponse]) -> Void) {
        guard let url = URL.urlForLocationDetails(name) else {
            completion([])
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion([])
                return
            }
            
            do {
                // Decodes the JSON into an array of GeocodingResponse
                let locationSuggestions = try JSONDecoder().decode([GeocodingResponse].self, from: data)
                completion(locationSuggestions)
            } catch {
                print("Failed to decode location suggestions: \(error)")
                completion([])
            }
        }.resume()
    }
    
    // func for current weather details
    func getCurrentWeather(lat: Double, lon: Double, completion: @escaping (WeatherResponse?) -> Void) {
        guard let url = URL.urlForCurrentWeather(lat: lat, lon: lon) else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            
            do {
                let weatherResponse = try JSONDecoder().decode(WeatherResponse.self, from: data)
                completion(weatherResponse)
            } catch {
                print("Failed to decode Current weather response: \(error)")
                completion(nil)
            }
        }.resume()
    }
    
    // func for hourly weather
    func getHourlyForecast(lat: Double, lon: Double, completion: @escaping (HourlyResponse?) -> Void) {
        guard let url = URL.urlForHourlyForecast(lat: lat, lon: lon) else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            
            do {
                let hourlyResponse = try JSONDecoder().decode(HourlyResponse.self, from: data)
                completion(hourlyResponse)
            } catch {
                print("Failed to decode hourly response: \(error)")
                completion(nil)
            }
        }.resume()
    }
    
    // func for daily weather
    func getDailyForecast(lat: Double, lon: Double, completion: @escaping (DailyResponse?) -> Void) {
        guard let url = URL.urlForDailyForecast(lat: lat, lon: lon) else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            
            do {
                let dailyResponse = try JSONDecoder().decode(DailyResponse.self, from: data)
                completion(dailyResponse)
            } catch {
                print("Failed to decode daily response: \(error)")
                completion(nil)
            }
        }.resume()
        
    }
    
    // Moon Phases and other weather details
    func getOtherBasicWeather(lat: Double, lon: Double, completion: @escaping (OtherBasicInfoResponse?) -> Void) {
        guard let url = URL.urlForOtherBasicWeather(lat: lat, lon: lon) else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            
            do {
                let otherBasicInfoResponse = try JSONDecoder().decode(OtherBasicInfoResponse.self, from: data)
                completion(otherBasicInfoResponse)
            } catch {
                print("Failed to decode OtherBasicWeatherInfo response: \(error)")
                completion(nil)
            }
        }.resume()
    }
    
    // AQI indicating value and other weather details
    func getOtherBasicWeather2(lat: Double, lon: Double, completion: @escaping (OtherBasicInfoResponse2?) -> Void) {
        guard let url = URL.urlForOtherBasicWeatherInfo2(lat: lat, lon: lon) else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            
            do {
                let otherBasicInfoResponse2 = try JSONDecoder().decode(OtherBasicInfoResponse2.self, from: data)
                completion(otherBasicInfoResponse2)
            } catch {
                print("Failed to decode OtherBasicWeatherInfo response: \(error)")
                completion(nil)
            }
        }.resume()
    }
}
