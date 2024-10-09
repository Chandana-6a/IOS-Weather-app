//
//  WindSpeed.swift
//  WeatherApp
//
//  Created by chandana on 21/09/24.
//

import SwiftUI

struct WindSpeed: View {
    var windSpeed: Double

    var body: some View {
        VStack(spacing:0){
            ZStack{

                Image("wind")
                    .clipShape(RoundedRectangle(cornerSize: CGSize(width: 25, height: 25)))
                    .overlay(
                        VStack(spacing: -5){
                            Text(windSpeed.roundDouble())
                                .font(.system(size: 48, weight: .bold))
                            
                            Text("Km/h")
                                .font(.system(size: 14, weight: .regular))
                            
                        }
                            .foregroundStyle(Color(.white))
                            .padding(.leading, 75)
                            .padding(.top, 70)
                    )
                Image("Mini Noise Texture")
                    .resizable()
                    .frame(width: 170, height: 160)
                    .clipShape(RoundedRectangle(cornerSize: CGSize(width: 25, height: 25)))
                    .blendMode(.overlay)
            }
            Text("Wind Speed")
                .font(.system(size: 12, weight: .regular))
                .foregroundColor(.umbrellaTempCard)
                .padding(.top, 10)
        }
        .frame(width: 170, height: 187)
    }
}

#Preview {
    WindSpeed(windSpeed: 12)
}
