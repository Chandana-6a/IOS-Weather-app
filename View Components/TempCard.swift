//
//  TempCard.swift
//  WeatherApp
//
//  Created by chandana on 26/08/24.
//

import SwiftUI

struct TempCard: View {
    var temp: Double
    var feels_like: Double
    var description: String
    var body: some View {
        
        VStack(spacing: 15){
            ZStack{
                BlurView(radius: 10)
                    .frame(width: UIScreen.main.bounds.width - 40, height: 233)
                    .clipShape(RoundedRectangle(cornerRadius: 25))
                
                VStack{
                    Text("\(temp.roundDouble())")
                        .font(.system(size: 96, weight: .bold))
                        .foregroundColor(.white)+Text("°").font(.system(size: 96, weight: .thin)).foregroundColor(.white)
                    VStack{
                        
                        HStack(spacing: 0){
                            Text("Feels Like ")
                            Text("\(feels_like.roundDouble())°")
                        }
                        Text(description)
                    }
                    .font(.system(size: 15, weight: .light))
                    .foregroundColor(.white)
                }
                
                .frame(width: UIScreen.main.bounds.width - 40, height: 233)
                .background(            
                    LinearGradient(
                    gradient: Gradient(colors: [Color.tempCardDark.opacity(0), Color.tempCardLow.opacity(0.15)]),
                    startPoint: UnitPoint(x: 0.45, y: -0.15),
                    endPoint: .bottomLeading
                ))
                .cornerRadius(25)
                
                .overlay(RoundedRectangle(cornerSize: CGSize(width: 25, height: 25)).stroke( lineWidth: 0.5)
                    .foregroundStyle(LinearGradient(
                        gradient: Gradient(
                            stops: [
                                .init(color: .black.opacity(0), location: 0.0),
                                .init(color: .searchLineT, location: 0.2)])
                        ,startPoint: UnitPoint(x: 0.25, y: 0),
                        endPoint: .bottomLeading)
                    ))                
            }
            HStack(spacing: 0){
                Text("It is advisable to ")
                    .foregroundStyle(Color.adviceTempCard) +
                Text("carry an umbrella ")
                    .foregroundStyle(Color.umbrellaTempCard) +
                Text("today, as there is a possibility of ")
                    .foregroundStyle(Color.adviceTempCard) +
                Text("rain")
                    .foregroundStyle(Color.rainTempCard) +
                Text(".")
                    .foregroundStyle(Color.adviceTempCard)
            }
            .font(.system(size: 12, weight: .regular))
            .frame(width: 249, height: 30)
            .multilineTextAlignment(.center)

        }
    }
}

#Preview {
    TempCard(temp: 20, feels_like: 25, description: "sunny")
}

extension Double {
    func roundDouble() -> String {
        return String(format: "%.0f", self)
    }
}
