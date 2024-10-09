//
//  HourlyWeather.swift
//  WeatherApp
//
//  Created by chandana on 28/08/24.
//

import SwiftUI

struct HourlyWeather: View {

    let hours: [(String, String, String, String)]

    var body: some View {
        VStack(spacing: 15){
            ZStack {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 45) {
                        ForEach(0..<hours.count, id: \.self) { index in
                            GeometryReader { geometry in
                                let currentScale = scale(for: geometry)
                                HourlyWeatherCard(
                                    hour: hours[index].0,
                                    precipitation: hours[index].1,
                                    temperature: hours[index].2,
                                    icon: hours[index].3,
                                    showStroke: currentScale >= 1.25
                                )
                                .scaleEffect(currentScale)
                                .animation(.easeOut(duration: 0.2), value: currentScale)
                            }
                        }
                    }
                    .padding(.leading, 10)
                    .padding(.trailing, 40)
                    .padding(.top, 27)
                }
                .frame(width: 391, height: 169)
                
                
                // Gradient Overlay
                LinearGradient(
                    gradient: Gradient(stops: [
                        .init(color: Color.hourBGgrad.opacity(0.97), location: 0.02),
                        .init(color: .black.opacity(0.2), location: 0.3),
                        .init(color: .black.opacity(0.2), location: 0.77),
                        .init(color: Color.hourBGgrad.opacity(0.97), location: 0.98)
                    ]),
                    startPoint: .bottomLeading,
                    endPoint: .bottomTrailing
                )
                .frame(width: 391, height: 169)
                .mask(
                    Rectangle()
                        .frame(width: 391, height: 169)
                )
                .allowsHitTesting(false)
            }
            .clipShape(RoundedRectangle(cornerSize: CGSize(width: 25, height: 25)), style: FillStyle())
            .overlay(
                RoundedRectangle(cornerRadius: 25)
                    .strokeBorder(style: StrokeStyle(lineWidth: 1, dash: [1, 1]))
                    .foregroundStyle(LinearGradient(gradient: Gradient(
                        stops: [
                            .init(color: .searchLineT.opacity(0.7), location: 0.0),
                            .init(color: .hourWeatherStroke.opacity(0.4), location: 0.05),
                            .init(color: .hourWeatherStroke.opacity(0), location: 1.0)]),
                                                    startPoint: .top,
                                                    endPoint: .bottom)))
            Text("Hourly Weather")
                .font(.system(size: 12, weight: .regular))
                .foregroundStyle(Color(.umbrellaTempCard))

        }
    }
    
    private func scale(for geometry: GeometryProxy) -> CGFloat {
        // Calculate the scale based on the distance from the center
        let xOffset = geometry.frame(in: .global).midX
        let screenWidth = UIScreen.main.bounds.width - 50
        let distanceFromCenter = abs(screenWidth / 2 - xOffset)
        
        // Larger scale for the center element
        return distanceFromCenter < 30 ? 1.25 : 1.05
    }
}

#Preview {
    HourlyWeather(hours: [("5pm", "40%", "25", "Cloud with rain"),
                           ("6pm", "5%", "23", "Cloud"),
                           ("7pm", "2%", "22", "Moon with clouds"),
                           ("8pm", "0%", "21", "Moon with stars"),
                           ("9pm", "25%", "19", "Moon with stars"),
                           ("10pm", "50%", "17", "Cloud with moon"),
                           ("11pm", "90%", "16", "Cloud with rain"),
                           ("6pm", "5%", "23", "Cloud"),
                           ("7pm", "2%", "22", "Moon with clouds"),
                           ("8pm", "0%", "21", "Moon with stars"),
                           ("9pm", "25%", "19", "Moon with stars"),
                    ("10pm", "50%", "17", "Cloud with moon")])
}

struct HourlyWeatherCard: View {
    var hour: String
    var precipitation: String
    var temperature: String
    var icon: String
    var showStroke: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            Text(hour)
                .font(.system(size: 8, weight: .regular))
                .frame(width: 34, height: 14)
                .background(Color(.hourlyhour))
                .cornerRadius(23)
                .padding(.top, -22)
            VStack(spacing: 0) {
                Image(icon)
                Text(precipitation)
                    .font(.system(size: 8, weight: .regular))
                    .foregroundStyle(Color(.precipitationPercentHW))
            }
            .padding(.bottom, 20)
            HStack(spacing: 2) {
                Text(temperature)
                    .font(.system(size: 19, weight: .heavy))
                    .foregroundColor(.white)
                Text("°")
                    .font(.system(size: 11, weight: .ultraLight))
                    .foregroundColor(.white)
                    .frame(alignment: .topLeading)
            }
//            .padding(.top, 10)
            .padding(.bottom, -35)
        }
        .frame(width: 42.5, height: 115)
        .background(LinearGradient(gradient: Gradient(colors: [Color.hourDark.opacity(0.3), Color.hourLight.opacity(0.2)]),
                                   startPoint: .top,
                                   endPoint: .bottom))
        .cornerRadius(11)
        .overlay(
            showStroke ? RoundedRectangle(cornerSize: CGSize(width: 11, height: 11))
                .stroke(lineWidth: 1)
                .foregroundStyle(LinearGradient(gradient: Gradient(stops: [
                    .init(color: .white.opacity(0.4), location: 0.0),
                    .init(color: .black.opacity(0), location: 0.7)
                ]),
                                                startPoint: .top,
                                                endPoint: .bottom)) : nil
        )
    }
}

