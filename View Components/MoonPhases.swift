//
//  MoonPhases.swift
//  Random2
//
//  Created by chandana on 11/09/24.
//

import SwiftUI

struct MoonPhases: View {
    var moonPhaseValue: Double

    var body: some View {
        
        let (description, image, percentage, rotationAngle) = descriptionAndImage(for: moonPhaseValue)
        
        VStack(spacing: 0){
            ZStack {
                
                Image("MiniGridImage")
                    .frame(width: 170, height: 160)
                    .cornerRadius(25)
                
                Image("BlackTopRightMoonBG")
                
                ZStack {
                    Image("Moon")
                    image
                        .rotationEffect(.degrees(rotationAngle ?? 0))
                }
                .padding(.top, -30)
                VStack(spacing: 5){
                    Text(description)
                        .font(.system(size: 11, weight: .light))
                        

                        .foregroundStyle(Color.moonPhaseFont)
                    Text(percentage)
                        .font(.system(size: 11, weight: .bold))
                        .foregroundStyle(Color.moonPhaseFont)
                }
                .padding(.top, 100)
                
                Image("Stars")
            }
            .frame(width: 170, height: 160)
            
            Spacer()
            
            Text("Moon Phase")
                .font(.system(size: 12, weight: .regular))
                .foregroundColor(.umbrellaTempCard)
                .padding(.top, 10)
        }
        .frame(width: 170, height: 190, alignment: .center)
    }
}

#Preview {
    MoonPhases(moonPhaseValue: 0.85)
}

private func descriptionAndImage(for value: Double) -> (String, Image, String, Double?) {
    let ranges: [(Range<Double>, String, Image, Double?)] = [
        (0.01..<0.24, "Waxing Crescent", Image("Waxing Crescent"), nil),
        (0.24..<0.27, "First Quarter", Image("First Quarter"), nil),
        (0.27..<0.36, "Waxing Gibbous", Image("Waxing Gibbous1"), nil),
        (0.36..<0.44, "Waxing Gibbous", Image("Waxing Gibbous2"), nil),
        (0.44..<0.49, "Waxing Gibbous", Image("Waxing Gibbous3"), nil),
        (0.49..<0.52, "Full Moon", Image("Moon"), nil),
        (0.52..<0.62, "Waning Gibbous", Image("Waning Gibbous1"), nil),
        (0.62..<0.74, "Waning Gibbous", Image("Waning Gibbous2"), 10),
        (0.74..<0.77, "Third Quarter", Image("First Quarter"), 180),
        (0.77..<0.99, "Waning Crescent", Image("Waning Crescent"), 20),
        (0.99..<1.0, "New Moon", Image("New Moon"), nil)
    ]
    

    for (range, description, image, rotationAngle) in ranges {
        if range.contains(value) {
            // Calculate the percentage
            var percentage = value * 200
            
            // If percentage is greater than 100
            if percentage > 100 {
                percentage = 100 - (percentage - 100)
            }
            
            // Convert the percentage to a string representation
            let percentageString = String(format: "%.0f%%", percentage)
            
            // Return the description, image, percentage string, and rotation angle
            return (description, image, percentageString, rotationAngle)
        }
    }

        return ("New Moon", Image("New Moon"), "0%", nil)
}

// MoonPhases on Mainview
struct MainMoonPhases: View {
    var moonPhaseValue: Double
    var body: some View {
        VStack{
            let (_, image, _, rotationAngle) = descriptionAndImage(for: moonPhaseValue)
            
            ZStack {
                Image("Moon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 270, height: 270)

                image
                    .resizable()
                    .scaledToFit()
                    .frame(width: 270, height: 270)
                    .rotationEffect(.degrees(rotationAngle ?? 0))
            }
        }
    }
}

#Preview {
    MainMoonPhases(moonPhaseValue: 0.75)
}
