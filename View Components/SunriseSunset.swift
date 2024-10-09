//
//  SunriseSunset.swift
//  WeatherApp
//
//  Created by chandana on 28/08/24.
//

import SwiftUI

struct SunriseSunset: View {

    var sunriseTime: Double
    var sunsetTime: Double
    var currentTime: Double
    var timezone: Int
    
    var body: some View {
        VStack(spacing: 0){
            VStack(spacing: 0) {
                ZStack {
                    // Arc indicating the sun's path
                    SunRiseArc()
                        .stroke(
                            LinearGradient(
                                gradient: Gradient(stops: [
                                    .init(color: .sunRiseArcL, location: 0.0),
                                    .init(color: .sunSetArcD, location: 1.0)
                                ]),
                                startPoint: .leading,
                                endPoint: .trailing
                            ),
                            style: StrokeStyle(lineWidth: 1, lineCap: .round)
                        )
                        .frame(height: 80)
                        .padding(.top, 95)
                    
                    ZStack {
                        // The glow effect
                        Circle()
                            .fill((Color.white).opacity(0.6))
                            .frame(width: 20, height: 20)
                            .blur(radius: 7)
                            .offset(x: calculateXOffset(currentTime: currentTime), y: calculateYOffset(currentTime: currentTime))
                            .opacity(currentTime >= sunriseTime && currentTime <= sunsetTime ? 1.0 : 0.0)
                        // Circle indicating the sun's current position on the arc
                        Circle()
                            .fill(Color.white)
                            .frame(width: 15, height: 15)
                            .offset(x: calculateXOffset(currentTime: currentTime), y: calculateYOffset(currentTime: currentTime))
                            .opacity(currentTime >= sunriseTime && currentTime <= sunsetTime ? 1.0 : 0.0)
                    }
                    // Text showing the current time (for demonstration)
                    Text(formatTimestampTo12Hour2(currentTime, timezoneOffset: timezone))
                        .font(.system(size: 8, weight: .regular))
                        .foregroundColor(.white)
                        .offset(x: calculateXOffset(currentTime: currentTime), y: calculateYOffset(currentTime: currentTime) - 18)
                        .opacity(currentTime >= sunriseTime && currentTime <= sunsetTime ? 1.0 : 0.0)
                    
                }
                .frame(height: 80)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.blackGradientLow, Color.hourBGgrad]),
                        startPoint: .leading,
                        endPoint: .center
                    )
                )
                
                
                Rectangle()
                    .fill(Color.sunrisesetLine)
                    .frame(height: 1)
                
                HStack(spacing: 10) {
                    SunRiseSetTimings(timing: sunriseTime, zone: timezone, RiseSet: "Sunrise", wordColorS: .sunRiseWordStart, wordColorE: .sunSetWordStart)
                    
                    Rectangle()
                        .strokeBorder(style: StrokeStyle(lineWidth: 1, dash: [2]))
                        .foregroundStyle(LinearGradient(gradient: Gradient(
                            colors: [.sunrisesetLine]),
                                                        startPoint: .top,
                                                        endPoint: .bottom))
                        .frame(width: 1, height: 80)
                        .padding(.top, -12)
                    
                    
                    SunRiseSetTimings(timing: sunsetTime, zone: timezone, RiseSet: "Sunset", wordColorS: .sunSetWordStart, wordColorE: .sunSetWordEnd)
                }
                .frame(height: 79)
                .padding(.top, 8)
            }
            .frame(width: 170, height: 160)
            .cornerRadius(25)
            .overlay(RoundedRectangle(cornerRadius: 25)
                .stroke(LinearGradient(
                    gradient: Gradient(colors: [Color.d2DBGT.opacity(0), Color.d2DBGT]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ), lineWidth: 0.5))
            
            
            Spacer()
            
            Text("Sunrise and Sunset")
                .font(.system(size: 12, weight: .regular))
                .foregroundColor(.umbrellaTempCard)
            
        }
        .frame(width: 170, height: 190, alignment: .center)
    }
    
    // Calculates the offsets for the circle based on current time
    private func calculateXOffset(currentTime: Double) -> CGFloat {
        let totalDaylight = sunsetTime - sunriseTime
        let position = (currentTime - sunriseTime) / totalDaylight
        let arcWidth: CGFloat = 150 // Adjust based on frame width
        return arcWidth * CGFloat(position) - (arcWidth / 2)
    }
    
    private func calculateYOffset(currentTime: Double) -> CGFloat {
        let totalDaylight = sunsetTime - sunriseTime
        let position = (currentTime - sunriseTime) / totalDaylight
        let arcHeight: CGFloat = 35 // Adjust the height for the curve's peak
        return -arcHeight * sin(position * .pi)+27
    }
}

  
// Custom arc shape for sunrise/sunset path
struct SunRiseArc: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.addArc(center: CGPoint(x: rect.midX, y: rect.maxY), // Adjust y for a better curve
                    radius: rect.width / 1.8,
                    startAngle: .degrees(210),
                    endAngle: .degrees(330),
                    clockwise: false)
        return path
    }
}


struct SunRiseSetTimings: View {
    var timing: Double
    var zone: Int
    
    var RiseSet: String
    var wordColorS: Color
    var wordColorE: Color
    
    var formattedTime: String {
        formatTimestampTo12Hour2(timing, timezoneOffset: zone)
    }
    var body: some View {
        VStack {
            Text(formattedTime)
                .font(.system(size: 12, weight: .regular))
                .foregroundStyle(Color(.white))
            
            Text(RiseSet)
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(LinearGradient(colors: [wordColorS, wordColorE], startPoint: .leading, endPoint: .trailing))
        }
    }
}
 
func formatTimestampTo12Hour2(_ timestamp: Double, timezoneOffset: Int) -> String {

    let date = Date(timeIntervalSince1970: timestamp)

    let formatter = DateFormatter()
    formatter.dateFormat = "h:mma" // 12-hour format
    formatter.locale = Locale(identifier: "en_US_POSIX") // Ensure consistent AM/PM format
    formatter.amSymbol = " am"
    formatter.pmSymbol = " pm"
    
    // Applys the timezone offset (in seconds)
    let timeZone = TimeZone(secondsFromGMT: timezoneOffset)
    formatter.timeZone = timeZone
    
    // Returns the formatted date as a string
    return formatter.string(from: date).lowercased() // Return formatted time
}
  
