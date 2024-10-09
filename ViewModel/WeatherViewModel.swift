//
//  WeatherViewModel.swift
//  Final Travel App
//
//  Created by chandana on 16/08/24.
//


import Foundation
import Combine

class WeatherViewModel: ObservableObject {
    
    @Published var geocodingResponse: GeocodingResponse?
    @Published var weatherResponse: WeatherResponse?
    @Published var hourlyResponse: HourlyResponse?
    @Published var dailyResponse: DailyResponse?
    @Published var otherBasicInfoResponse: OtherBasicInfoResponse?
    @Published var otherBasicInfoResponse2: OtherBasicInfoResponse2?

    @Published var recentSearches: [String] = []
    @Published var locationSuggestionsResponse: [String] = []
    private let recentSearchesKey = "recentSearches"
    
    @Published var country: String = ""
    @Published var message: String = ""


    
    var name: String {
        geocodingResponse?.name ?? ""
    }
    var state: String {
        geocodingResponse?.state ?? ""
    }
  
    var lat: Double {
        geocodingResponse?.lat ?? 0.0
    }
    var lon: Double {
        geocodingResponse?.lon ?? 0.0
    }
    
    var temp: Double {
        weatherResponse?.main.temp ?? 0.0
    }
    
    var feels_like: Double {
        weatherResponse?.main.feels_like ?? 0.0
    }
    
    var main: String {
        weatherResponse?.weather.first?.main ?? ""
    }
    
    var description: String {
        weatherResponse?.weather.first?.description ?? ""
    }
    
    var windSpeed: Double {
//        return Double((weatherResponse?.wind.speed ?? 0.0) * 3.6)
        (weatherResponse?.wind.speed ?? 0.0) * 3.6
    }
    
    var precipprob: Double {
        otherBasicInfoResponse?.days.first?.precipprob ?? 0
    }
    
    var uv: Int{
        otherBasicInfoResponse2?.data.first?.uv ?? 0
    }
    
    var aqi: Double {
        otherBasicInfoResponse2?.data.first?.aqi ?? 0
    }
    
    var sunrise: Double {
        weatherResponse?.sys.sunrise ?? 0.0
    }

    var sunset: Double {
        weatherResponse?.sys.sunset ?? 0.0
    }
    
    var timezone: Int{
        weatherResponse?.timezone ?? 0
    }
    
    var currentTime: Double {
        return Date().timeIntervalSince1970
    }
    
    func fetchWeather(name: String) {
        guard let escapedLocation = name.escaped() else {
            DispatchQueue.main.async {
                self.message = "Invalid city name"
            }
            return
        }
        
        saveSearch(name: name)

        // Fetch Geocoding (lat/lon)
        WeatherService().getLocationDetails(name: escapedLocation) { geocodingResponse in
            DispatchQueue.main.async {
                if let geocodingResponse = geocodingResponse {
                    self.geocodingResponse = geocodingResponse
                    self.fetchCountryName(for: geocodingResponse.country) { country in
                                            self.country = country
                                        }

                    // Fetchs weather using lat/lon
                    self.fetchCurrentWeather(lat: geocodingResponse.lat, lon: geocodingResponse.lon)
                    self.fetchHourlyWeather(lat: geocodingResponse.lat, lon: geocodingResponse.lon)
                    self.fetchDailyWeather(lat: geocodingResponse.lat, lon: geocodingResponse.lon)
                    self.fetchOtherBasicWeather(lat: geocodingResponse.lat, lon: geocodingResponse.lon)
                    self.fetchOtherBasicWeather2(lat: geocodingResponse.lat, lon: geocodingResponse.lon)
                } else {
                    self.message = "Failed to fetch location details"
                }
            }
        }
    }

    // location suggestions function
    func fetchLocationSuggestions(name: String) {
        WeatherService().getLocationSuggestions(name: name) { [weak self] suggestions in
            guard let self = self else { return }

            // Debug print to verify the API response
            print("API Response: \(suggestions)")

            let group = DispatchGroup()
            var suggestionsWithCountryNames: [String] = []

            for suggestion in suggestions {
                group.enter()
                self.fetchCountryName(for: suggestion.country) { country in
                    let state = suggestion.state ?? "" // Default to empty string if state is nil
                    let formattedSuggestion: String
                    if state.isEmpty {
                        formattedSuggestion = "\(suggestion.name), \(country)"
                    } else {
                        formattedSuggestion = "\(suggestion.name), \(state), \(country)"
                    }
                    suggestionsWithCountryNames.append(formattedSuggestion)
                    group.leave()
                }
            }

            group.notify(queue: .main) {
                self.locationSuggestionsResponse = suggestionsWithCountryNames
            }
        }
    }

    // fetches current weather
    private func fetchCurrentWeather(lat: Double, lon: Double) {
        guard let url = URL.urlForCurrentWeather(lat: lat, lon: lon) else {
            print("Invalid URL")
            return
        }
        
        print("Fetching weather data from URL: \(url)")

        WeatherService().getCurrentWeather(lat: lat, lon: lon) { weatherResponse in
            DispatchQueue.main.async {
                if let weatherResponse = weatherResponse {
                    self.weatherResponse = weatherResponse
                    self.message = "Weather data fetched successfully"
                } else {
                    self.message = "Failed to fetch weather data"
                }
            }
        }
    }
    
//    fetches hourly weather data
    func fetchHourlyWeather(lat: Double, lon: Double) {
        guard URL.urlForHourlyForecast(lat: lat, lon: lon) != nil else {
            print("Invalid URL")
            return
        }
        
        WeatherService().getHourlyForecast(lat: lat, lon: lon) { hourlyResponse in
            DispatchQueue.main.async {
                if let hourlyResponse = hourlyResponse {
                    self.hourlyResponse = hourlyResponse
                    self.message = "Weather data fetched successfully"
                    
                } else {
                    print("Failed to fetch hourly weather data")
                }
            }
        }
    }
        
    // fetches daily weather of 7 days
    func fetchDailyWeather(lat: Double, lon: Double) {
        guard URL.urlForDailyForecast(lat: lat, lon: lon) != nil else {
            print("Invalid URL")
            return
        }
        
        WeatherService().getDailyForecast(lat: lat, lon: lon) { dailyResponse in
            DispatchQueue.main.async {
                if let dailyResponse = dailyResponse {
                    self.dailyResponse = dailyResponse
                    self.message = "Weather data fetched successfully"
                    
                } else {
                    print("Failed to fetch daily weather data")
                    self.message = "Failed to fetch daily weather data"
                }
            }
        }
    }
    
    // Moon Phases and other weather details
    func fetchOtherBasicWeather(lat: Double, lon: Double) {
        guard URL.urlForOtherBasicWeather(lat: lat, lon: lon) != nil else {
            print("Invalid URL of OtherBasicWeather")
            return
        }
        
        WeatherService().getOtherBasicWeather(lat: lat, lon: lon) { otherBasicInfoResponse in
            DispatchQueue.main.async {
                if let otherBasicInfoResponse = otherBasicInfoResponse {
                    self.otherBasicInfoResponse = otherBasicInfoResponse
                    self.message = "Weather data fetched successfully"
                    
                } else {
                    self.message = "Failed to fetch OtherBasicWeather data"
                }
            }
        }
    }
    
    // AQI indicating value and other weather details
    func fetchOtherBasicWeather2(lat: Double, lon: Double) {
        guard URL.urlForOtherBasicWeatherInfo2(lat: lat, lon: lon) != nil else {
            print("Invalid URL of OtherBasicWeather")
            return
        }
        
        WeatherService().getOtherBasicWeather2(lat: lat, lon: lon) { otherBasicInfoResponse2 in
            DispatchQueue.main.async {
                if let otherBasicInfoResponse2 = otherBasicInfoResponse2 {
                    self.otherBasicInfoResponse2 = otherBasicInfoResponse2
                    self.message = "Weather data fetched successfully"
                    
                } else {
                    self.message = "Failed to fetch OtherBasicWeather data"
                }
            }
        }
    }

    // Country code is converted to name
    private func fetchCountryName(for countryCode: String, completion: @escaping (String) -> Void) {
        CountryService().getCountryName(from: countryCode) { country in
            DispatchQueue.main.async {
                completion(country)
            }
        }
    }

    
    
    init() {
            loadRecentSearches()
        }
        
        // Save recent search
        private func saveSearch(name: String) {
            var searches = UserDefaults.standard.stringArray(forKey: recentSearchesKey) ?? []
            
            if !searches.contains(name) {
                searches.append(name)
                if searches.count > 5 { // Keep the latest 5
                    searches.removeFirst()
                }
                UserDefaults.standard.setValue(searches, forKey: recentSearchesKey)
                loadRecentSearches()
            }
        }
        
        // Load recent searches
        private func loadRecentSearches() {
            recentSearches = UserDefaults.standard.stringArray(forKey: recentSearchesKey) ?? []
        }
                
}



// converts 24 hour time to 12 hour time
extension WeatherViewModel {
    func formatTimestampTo12Hour(_ timestamp: Double, timezoneOffset: Int) -> String {
        // Create a date from the timestamp
        let date = Date(timeIntervalSince1970: timestamp)
        
        // Create the date formatter
        let formatter = DateFormatter()
        formatter.dateFormat = "ha" // 12-hour format
        formatter.locale = Locale(identifier: "en_US_POSIX") // Ensure consistent AM/PM format
        formatter.amSymbol = "am"
        formatter.pmSymbol = "pm"
        
        // Apply the timezone offset (in seconds)
        let timeZone = TimeZone(secondsFromGMT: timezoneOffset)
        formatter.timeZone = timeZone
        
        // Return the formatted date as a string
        return formatter.string(from: date).lowercased() // Return formatted time
    }
}

// date is converted to day
extension WeatherViewModel {
    func formatDay(from timestamp: Int) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE" // Full day name (e.g., "Monday")
        
        // Get today's date
        let today = Date()
        let calendar = Calendar.current
        
        // Check if the date is today
        if calendar.isDate(date, inSameDayAs: today) {
            return "Today"
        } else {
            return dateFormatter.string(from: date)
        }
    }
}

