//
//  BasicInfo.swift
//  WeatherApp
//
//  Created by chandana on 27/08/24.
//

import SwiftUI

struct BasicInfo: View {
    
    @EnvironmentObject var weatherVM: WeatherViewModel
    @State private var activeElement: Int = 0
    
    var body: some View {
        
        HStack(spacing: 23){
            
            Precip_UV(precipprob: weatherVM.precipprob, uv: weatherVM.uv)
//            Precip_UV(precipprob: 0, uv: 0)
                .clipShape(Rectangle())
                .frame(width: 170, height: 187)
//                .border(Color.white)

            
            HStack(spacing: 5) {
                
                Rectangle()
                    .strokeBorder(style: StrokeStyle(lineWidth: 1, dash: [2, 3]))
                    .frame(width: 1, height: 187)
                    .foregroundColor(Color.baseInfoLine)
                    .padding(.trailing, 5)
                
                // Dots
                VStack(spacing: 5) {
                    Circle()
                        .fill(activeElement == 0 ? Color.white : Color.gray)
                        .frame(width: 8, height: 8)
                        .padding(3) // tappable area
                        .contentShape(Rectangle())
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                activeElement = 0
                            }
                            print("AQI Indicator tapped")
                        }
                    Circle()
                        .fill(activeElement == 1 ? Color.white : Color.gray)
                        .frame(width: 8, height: 8)
                        .padding(3)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                activeElement = 1
                            }
                            print("Wind Speed tapped")
                        }
                }
                
                
                if activeElement == 0 {
                    AQIIndicator(aqiValue: weatherVM.aqi)
                        .padding(.top, 30)
                        .clipShape(Rectangle())
                        .frame(width: 170, height: 187)

//                        .border(Color.white)
                } else if activeElement == 1 {
                    WindSpeed(windSpeed: weatherVM.windSpeed)
//                        .border(Color.white)
                }
                   

            }
        }
        .frame(width: UIScreen.main.bounds.width - 40, height: 196)
    }
}

