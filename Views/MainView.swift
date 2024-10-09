//
//  MainView.swift
//  WeatherApp
//
//  Created by chandana on 25/08/24.


import SwiftUI

struct MainView: View {
    
    @EnvironmentObject var weatherVM: WeatherViewModel
    
    var body: some View {
        NavigationStack{
            ZStack(alignment: .top){
                LinearGradient(
                    gradient: Gradient(
                        stops: [
                            .init(color: .black, location: 0.4),
                            .init(color: .blackGradientLow, location: 1.0)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .edgesIgnoringSafeArea(.all)
                
                // Grainy texture overlay
                Image("Noise Texture")
                    .resizable()
                    .scaledToFill()
                    .blendMode(.overlay)
                    .edgesIgnoringSafeArea(.all)
                
                ScrollView{
                    
                    
                    VStack(spacing: 0){
                        ZStack(alignment: .top){
                            // Background based on weather
                            if weatherVM.main == "Rain" {
                                Image("Rain from Figma")
                                    .padding(.top, 76)
                            } else if weatherVM.main == "Snow" {
                                Image("Cold from Figma")
                                    .mask(LinearGradient(
                                        gradient: Gradient(
                                            stops: [
                                                .init(color: .black.opacity(0.7), location: 0.1),
                                                .init(color: .black.opacity(0.5), location: 0.8),
                                                .init(color: .black.opacity(0), location: 1.0)
                                            ]
                                        ),
                                        startPoint: .top,
                                        endPoint: .bottom
                                    ))
                                    .padding(.top, -60)
                            } else if weatherVM.sunrise < weatherVM.currentTime && weatherVM.sunset > weatherVM.currentTime {
                                Image("Sun from Figma")
                                    .padding(.top, -8)
                            } else {
                                MainMoonPhases(moonPhaseValue: weatherVM.otherBasicInfoResponse?.days.first?.moonphase ?? 0.6)
                                
                            }
                                                        
                            Image("Mini Noise Texture")
                                .blendMode(.overlay)
                                .edgesIgnoringSafeArea(.all)
                            
                            
                            gridView(width: UIScreen.main.bounds.width, height: 310, rows: 10, columns: 15)
                                .frame(width: UIScreen.main.bounds.width, height: 310)
                                .padding(.top, 73)
                            
                            // Location current weather details
                            TempCard(temp: weatherVM.temp, feels_like: weatherVM.feels_like, description: weatherVM.description)
                                .frame(width: UIScreen.main.bounds.width - 40, height: 233)
                                .padding(.top, 135)
                        }
                        
                        Rectangle()
                            .strokeBorder(style: StrokeStyle(lineWidth: 1, dash: [1, 1.5]))
                            .foregroundStyle(LinearGradient(gradient: Gradient(
                                stops: [
                                    .init(color: .black.opacity(0), location: 0.0),
                                    .init(color: .lineTempCardNear.opacity(0.4), location: 0.5),
                                    .init(color: .black.opacity(0), location: 1.0)]),
                                                            startPoint: .leading,
                                                            endPoint: .trailing)
                                             
                            )
                            .frame(width: UIScreen.main.bounds.width - 40, height: 1)
                            .padding(.top, -8)
                        
                        
                        
                        Rectangle()
                            .strokeBorder(style: StrokeStyle(lineWidth: 1, dash: [1, 1.5]))
                            .foregroundStyle(LinearGradient(gradient: Gradient(
                                stops: [
                                    .init(color: .black.opacity(0), location: 0.0),
                                    .init(color: .lineTempCardNear.opacity(0.4), location: 0.5),
                                    .init(color: .black.opacity(0), location: 1.0)]),
                                                            startPoint: .leading,
                                                            endPoint: .trailing))
                            .frame(width: UIScreen.main.bounds.width - 40, height: 1)
                            .padding(.top)
                            .padding(.bottom)

                        
                        
                        BasicInfo()
                            .padding(10)
                        
                        
                        // Next 24hr weather details
                        if let hourlyWeatherData = weatherVM.hourlyResponse?.list {
                            let hours = hourlyWeatherData.map { hour -> (String, String, String, String) in
                                let time = weatherVM.formatTimestampTo12Hour(Double(hour.dt), timezoneOffset: weatherVM.weatherResponse!.timezone )
                                //                                print("Formatted Time:", time)
                                
                                let precipitation = "\(Int(hour.pop * 100))%"
                                let temperature = "\(Int(hour.main.temp))"
                                
                                let apiIcon = hour.weather.first?.icon ?? "default-icon"
                                
                                let icon = customIconMapping[apiIcon] ?? "default-icon"
                                
                                return (time, precipitation, temperature, icon)
                            }
                            
                            HourlyWeather(hours: hours)
                                .padding()
                        } else {
                            Text("Loading hourly data...")
                        }
                        
                        
                        // Daily weather
                        if let dailyResponse = weatherVM.dailyResponse {
                            let weekWeather = dailyResponse.list.map { day -> DayWeather in
                                let dayName = weatherVM.formatDay(from: day.dt)
                                let minTemp = "\(Int(day.temp.min))°"
                                let maxTemp = "\(Int(day.temp.max))°"
                                let condition = day.weather.first?.description.capitalized ?? "N/A"
                                let apiIcon = day.weather.first?.icon ?? "default-icon"
                                let icon = customIconMapping[apiIcon] ?? "default-icon"
                                
                                let precipitationChance = "\(Int(day.pop * 100))%"
                                
                                return DayWeather(day: dayName, temperature1: minTemp, temperature2: maxTemp, condition: condition, icon: icon, precipitationChance: precipitationChance)
                            }
                            
                            DailyWeather(weekWeather: weekWeather)
                                .padding()
//                                .padding(.top, 60)
                        } else {
                            Text("Loading daily weather...")
                        }
                        
                        // SunriseSunset details and Moonphase
                        HStack(spacing: 23){
                            
                            SunriseSunset(sunriseTime: weatherVM.sunrise, sunsetTime: weatherVM.sunset, currentTime: weatherVM.currentTime, timezone: weatherVM.timezone)
                            
                            Rectangle()
                                .strokeBorder(style: StrokeStyle(lineWidth: 1, dash: [2, 3]))
                                .frame(width: 1, height: 195)
                                .foregroundColor(Color.baseInfoLine)
                            
                            MoonPhases(moonPhaseValue: weatherVM.otherBasicInfoResponse?.days.first?.moonphase ?? 0.25)
                            
                        }
                        .padding(.top)
                    }
                }
                
                // Details of the location
                LocationDetailsView(location: weatherVM.name, city: weatherVM.state, country: weatherVM.country)
                    .background(
                        BlurView(radius: 5)
                            .frame(width: UIScreen.main.bounds.width, height: 131)
                    )
                    .ignoresSafeArea()
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    MainView()
        .environmentObject(WeatherViewModel())
}

//#Preview {
//    SearchView()
//        .environmentObject(WeatherViewModel())
//}


let customIconMapping: [String: String] = [
    "01d": "Clear Sky Day",    // clear sky day
    "01n": "Clear Sky Night",  // clear sky night
    "02d": "Cloudy Day",
    "02n": "Cloudy Night",
    "03d": "Cloudy Day",
    "03n": "Cloudy Night",
    "04d": "Rain Possibility",
    "04n": "Rain Possibility",
    "09d": "Light Rain",
    "09n": "Light Rain",
    "10d": "Heavy Rain",
    "10n": "Heavy Rain",
    "11d": "Thunder Storm",
    "11n": "Thunder Storm",
    "13d": "Snowflake",
    "13n": "Snowflake",

]
