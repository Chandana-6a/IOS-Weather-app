//
//  LocationDetailsView.swift
//  WeatherApp
//
//  Created by chandana on 04/09/24.
//

import SwiftUI

struct LocationDetailsView: View {
        
    var location : String
    var city : String
    var country: String
   
    var body: some View {
        NavigationStack{
            HStack(alignment: .bottom, spacing: 0) {
                VStack(alignment: .leading, spacing: 2) {
                    Text(location)
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.white)
                    
                    HStack(spacing: 0){
                        Text("Place in")
                        Text(" \(city), ")
                            .opacity(city.isEmpty ? 0 : 1)
                        Text(country)
                            .foregroundStyle(Color(.descLoca))
                        
                    }
                    .foregroundStyle(Color(.descLoca))
                    .font(.system(size: 14, weight: .regular))
                }
            
                Spacer()

                NavigationLink(destination: SearchView()) {
                    Image("search")
                        .resizable()
                        .frame(width: 31, height: 31)
                        
                        .padding(.trailing, 10)
                        .padding(.bottom)
                }
            }
            .padding()
            .frame(width: UIScreen.main.bounds.width, height: 131, alignment: .bottom)
            .overlay(
                Rectangle()                
                    .strokeBorder(style: StrokeStyle(lineWidth: 1, dash: [2]))
                    .foregroundStyle(LinearGradient(gradient: Gradient(colors: [Color.searchLineT.opacity(0.5), Color.searchLineB.opacity(0)]),
                                                    startPoint: .top,
                                                    endPoint: .bottom))
                    .frame(width: 1, height: 114)
                    .padding(.top, 90)
                    .padding(.leading, UIScreen.main.bounds.width - 170)
            )
        }
    }
}
#Preview {
    LocationDetailsView(location: "Itaewon", city: "Seoul", country: "South Korea")
}
    
//    @State private var locationText = ""



    
