//
//  WeeklyWeather.swift
//  WeatherApp
//
//  Created by chandana on 28/08/24.
//

import SwiftUI

struct DailyWeather: View {
    
    let weekWeather: [DayWeather]
    
    var body: some View {
        VStack(spacing: 10) {
            VStack(spacing: 0) {
                ForEach(weekWeather.indices, id: \.self) { index in
                    let dayWeather = weekWeather[index]
                    HStack(spacing: 10) {
                        Text(dayWeather.day)
                            .font(.system(size: 16, weight: .semibold))
                            .frame(width: 100, alignment: .leading)
                        
                        HStack(spacing: 0){
                            Text(dayWeather.temperature1)
                            Text("/")
                            Text(dayWeather.temperature2)
                        }
                        .font(.system(size: 16, weight: .semibold))
                        .frame(width: 70, alignment: .leading)
                        
                        HStack(spacing: 5) {
                            Image(dayWeather.icon)
                            Text(dayWeather.condition)
                                .font(.system(size: 10, weight: .light))
                        }
                        .frame(width: 125, alignment: .leading)
                        
                        HStack(spacing: 3) {
                            Image("RainDroplet")
                            Text(dayWeather.precipitationChance)
                                .font(.system(size: 8, weight: .regular))
                                .foregroundColor(.precipitationPercentHW)
                        }
                        .frame(width: 35, alignment: .leading)
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 10)
                    .foregroundColor(.white)
                    
                    if index < weekWeather.count - 1 {
                        Rectangle()
                            .fill(Color.d2DLine)
                            .frame(width: 390, height: 1)
                    }
                }
                .frame(width: 391, alignment: .leading)
            }
            .frame(width: 391, height: 339, alignment: .leading)
            .background(
                LinearGradient(
                    gradient: Gradient(
                        stops: [
                            .init(color: .d2DBGT.opacity(0.2), location: 0.0),
                            .init(color: .d2DLine.opacity(0), location: 0.5),
                            .init(color: .d2DLine.opacity(0), location: 1.0),
                        ]
                    ),
                    startPoint: .top,
                    endPoint: .bottom
                ))
            .cornerRadius(30)
            
            Text("Weather this week")
                .font(.system(size: 12, weight: .regular))
                .foregroundColor(.umbrellaTempCard)
        }
    }
}

#Preview {
    DailyWeather(weekWeather: [ DayWeather(day: "Today", temperature1: "16°", temperature2: "35°", condition: "Sunny Today", icon: "US Weather Condition", precipitationChance: "5%"),
                                DayWeather(day: "Monday", temperature1: "16°", temperature2: "35°", condition: "Clear Sky", icon: "US Weather Condition", precipitationChance: "0%"),
                                DayWeather(day: "Tuesday", temperature1: "16°", temperature2: "35°", condition: "Rain Possibility", icon: "US Weather Condition", precipitationChance: "40%"),
                                DayWeather(day: "Wednesday", temperature1: "16°", temperature2: "35°", condition: "Heavy Rain", icon: "US Weather Condition", precipitationChance: "100%"),
                                DayWeather(day: "Thursday", temperature1: "16°", temperature2: "35°", condition: "Cloudy Sky", icon: "US Weather Condition", precipitationChance: "35%"),
                                DayWeather(day: "Friday", temperature1: "16°", temperature2: "35°", condition: "Mostly Sunny", icon: "US Weather Condition", precipitationChance: "1%"),
                                DayWeather(day: "Saturday", temperature1: "16°", temperature2: "35°", condition: "Rain Possibility", icon: "US Weather Condition", precipitationChance: "60%")])
}

struct DayWeather: Identifiable {
    let id = UUID()
    let day: String
    let temperature1: String
    let temperature2: String
    let condition: String
    let icon: String
    let precipitationChance: String
}

