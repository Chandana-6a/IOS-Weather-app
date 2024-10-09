//
//  AQIIndicator.swift
//  WeatherApp
//
//  Created by chandana on 27/08/24.
//

import SwiftUI

struct AQIIndicator: View {
    @State var aqiValue: Double = 0

    var body: some View {
        
        let (description, category) = descriptionAndCategory(for: aqiValue)

        VStack(spacing:0){
            ZStack{
                Image("AQIBG")
                    .clipShape(RoundedRectangle(cornerSize: CGSize(width: 25, height: 25)))
                    .padding(.top, -60)
                Image("Mini Noise Texture")
                    .resizable()
                    .frame(width: 170, height: 160)
                    .clipShape(RoundedRectangle(cornerSize: CGSize(width: 25, height: 25)))
                    .blendMode(.overlay)
                    .padding(.top, -60)
//                Image("MiniGridImage")
                gridView(width: 170, height: 160, rows: 20, columns: 20)
//                    .resizable()
                    .frame(width: 170, height: 160)
                    .clipShape(RoundedRectangle(cornerSize: CGSize(width: 25, height: 25)))   
                                    .blendMode(.overlay)
.padding(.top, -60)
               

                ZStack{
                    
                    // AQI Arc
                    AQIArc()
                        .stroke(
                            LinearGradient(
                                gradient: Gradient(stops: [
                                    .init(color: .green, location: 0.0),
                                    .init(color: .yellow, location: 0.13),
                                    .init(color: .orange, location: 0.3),
                                    .init(color: .red, location: 0.53),
                                    .init(color: .purple, location: 0.85),
                                    .init(color: .maroonForAQI, location: 1.0)
                                ]),
                                startPoint: .leading,
                                endPoint: .trailing
                            ),
                            style: StrokeStyle(lineWidth: 12, lineCap: .round)
                        )
                        .frame(width: 132, height: 132)
                        .overlay(
                            VStack(spacing:0) {
                                Text(description)
                                    .font(.system(size: 8, weight: .light))
                                    .frame(width: 142, height:20)
                                    .multilineTextAlignment(.center)
                                    .padding(.top, -60)
                                
                                Text("\(Int(aqiValue))")
                                    .font(.system(size: 24, weight: .bold))
                                    .padding(.top, 20)
                                
                                Text(category)
                                    .font(.system(size: 12, weight: .light))
                                    .frame(width: 101, height:30)
                            }
                                .foregroundColor(.white)
                        )
                    
                    
                    // Indicator Circle
                    ZStack {
                        // glow circle
                        Circle()
                            .fill((Color.white).opacity(0.6))
                            .frame(width: 30, height: 30)
                            .blur(radius: 5)
                            .offset(x: 66 * cos(angle(for: aqiValue)),
                                    y: 66 * sin(angle(for: aqiValue)))
                        
                        // The main circle
                        Circle()
                            .fill(Color.white)
                            .frame(width: 11, height: 11)
                            .overlay(
                                Circle()
                                    .stroke(Color.white, lineWidth: 4.5)
                            )
                            .offset(x: 66 * cos(angle(for: aqiValue)),
                                    y: 66 * sin(angle(for: aqiValue)))
                    }
                }
                .frame(alignment: .bottom)
//                .border(Color.white)
            }
            .frame(width: 170, height: 160)

            Text("Air Quality")
                .font(.system(size: 12, weight: .regular))
                .foregroundColor(.umbrellaTempCard)
                .padding(.top, -20)
        }
        .frame(width: 170, height: 187)

    }
    private func angle(for value: Double) -> Double {
        // Map the AQI value to an angle between 180° (left) and 0° (right)
        let minValue: Double = 0
        let maxValue: Double = 330
        
        // Clamp the value between min and max
        let clampedValue = min(max(value, minValue), maxValue)
        
        // Map the value to the arc angle range
        let angleRange = 180.0
        let angle = (clampedValue / maxValue) * angleRange
        
        // Convert degrees to radians, and subtract 90° to rotate the arc to start from the left
        return (.pi * angle / 180.0) - .pi
    }    
}

struct AQIArc: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.addArc(
            center: CGPoint(x: rect.midX, y: rect.midY),
            radius: rect.width / 2,
            startAngle: .degrees(180),
            endAngle: .degrees(0),
            clockwise: false
        )
        return path
    }
}

#Preview {
    AQIIndicator(aqiValue: 270)
}


private func descriptionAndCategory(for value: Double) -> (String, String) {
    let ranges: [(Range<Double>, String, String)] = [
        (0..<50, "No pollution concerns", "Good"),
        (50..<100, "Mild effects for sensitive individuals", "Moderate"),
        (100..<150, "Health effects for sensitive individuals", "Unhealthy for Sensitive Groups"),
        (150..<200, "Health effects for some; severe for sensitive.", "Unhealthy"),
        (200..<300, "High health risk for all", "Very Unhealthy")
    ]
    
    for (range, description, category) in ranges {
        if range.contains(value) {
            return (description, category)
        }
    }
        return ("Emergency conditions; everyone at risk.", "Hazardous")
}
