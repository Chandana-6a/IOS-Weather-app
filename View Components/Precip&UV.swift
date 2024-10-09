//
//  Precip&UV.swift
//  WeatherApp
//
//  Created by chandana on 21/09/24.
//

import SwiftUI

struct Precip_UV: View {
    var precipprob: Double
    var uv: Int
    var body: some View {
        VStack(spacing: 10){
            
            Image("Precipitation")
                .overlay(
                    HStack(spacing: 0){
                        Text(precipprob.roundDouble())
                            .font(.system(size: 25, weight: .bold))
                        Text("%")
                            .font(.system(size: 25, weight: .light))
                    }
                        .padding(.leading, 70)
                        .foregroundStyle(Color(.uvDetail))
                    )
                
            Text("Precipitation")
                .font(.system(size: 12, weight: .regular))
                .foregroundStyle(Color(.umbrellaTempCard))

            Image("Uv")
                .overlay(
                    HStack(spacing: 0){
                        Text("\(uv)")
                            .font(.system(size: 25, weight: .bold))
                            .frame(width: 40, alignment: .trailing)
                            .padding(.leading, 58)
                        
                        Text(uvdescription(for: uv))
                            .font(.system(size: 10, weight: .medium))
                            .frame(width: 50, alignment: .leading)
                            .padding(.leading, 10)
                    }
                        .foregroundStyle(Color(.uvDetail))
                )
            
            Text("UV Index")
                .font(.system(size: 12, weight: .regular))
                .foregroundStyle(Color(.umbrellaTempCard))
        }
    }
    private func uvdescription(for uv: Int) -> String {
        // Returns description based on the AQI value
        if uv < 3 {
            return "Low"
        } else if uv < 6 {
            return "Moderate"
        } else if uv < 8 {
            return "High"
        } else if uv < 11 {
            return "Very high"
        } else {
            return "Extreme"
        }
    }
}

#Preview {
    Precip_UV(precipprob: 25, uv: 1)
}
