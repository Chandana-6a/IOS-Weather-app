//
//  SearchView.swift
//  WeatherApp
//
//  Created by chandana on 04/09/24.
//

import SwiftUI
import Combine

struct SearchView: View {
    
    @State private var locationInput = ""
    @State private var navigateToMainView = false
    @EnvironmentObject var weatherVM: WeatherViewModel
    
    private var shouldShowSuggestions: Bool {
        !locationInput.isEmpty && !weatherVM.locationSuggestionsResponse.isEmpty
    }

    private var formattedLocationInput: String {
        locationInput.capitalized
    }

    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                
                VStack() {
                    Rectangle()
                        .strokeBorder(style: StrokeStyle(lineWidth: 1, dash: [2]))
                        .frame(width: UIScreen.main.bounds.width, height: 1)
                        .foregroundStyle(.searchViewLine)
                    
                    
                    // Display Recent Searches or Location Suggestions
                    VStack{
                        if locationInput.isEmpty {
                            // Recent Searches
                            ForEach(weatherVM.recentSearches, id: \.self) { search in
                                HStack(spacing: 0) {
                                    Text(search)
                                        .font(.system(size: 14, weight: .regular))
                                    Spacer()
                                    Image(systemName: "arrow.up.right")
                                        .font(.system(size: 12, weight: .regular))
                                }
                                .padding()
                                .frame(width: UIScreen.main.bounds.width, height: 25, alignment: .leading)
                                
                                .onTapGesture {
                                    locationInput = search
                                    weatherVM.fetchWeather(name: search)
                                    navigateToMainView = true
                                }
                            }
                            
                        } else if shouldShowSuggestions {
                            // Auto-complete suggestions from API
                            ForEach(weatherVM.locationSuggestionsResponse, id: \.self) { suggestion in
                                HStack(spacing: 0) {
                                    Text(suggestion)
                                        .font(.system(size: 14, weight: .regular))
                                    
                                    Spacer()
                                    Image(systemName: "arrow.up.right")
                                        .font(.system(size: 12, weight: .regular))
                                    
                                }
                                .padding()
                                .frame(width: UIScreen.main.bounds.width, height: 25, alignment: .leading)
                                
                                .onTapGesture {
                                    locationInput = suggestion
                                    weatherVM.fetchWeather(name: suggestion)
                                    navigateToMainView = true
                                }
                            }
                        }
                    }
                    .foregroundStyle(.descLoca)
                    .padding()
                    
                    Spacer()
                }
                .padding(.top, 75)

                
                HStack {
                    TextField("", text: $locationInput)
                        .onChange(of: locationInput) {
                            if !locationInput.isEmpty {
                                // Fetchs suggestions as user types
                                weatherVM.fetchLocationSuggestions(name: locationInput)
                            }
                        }
                        .textFieldStyle(PlaceholderTextFieldStyle("Search for place", text: $locationInput))
                        .font(.system(size: 20, weight: .regular))
                    
                    Spacer()
                    
                    Button(action: {
                        if !locationInput.isEmpty {
                            weatherVM.fetchWeather(name: formattedLocationInput)
                            navigateToMainView = true
                        }
                    }) {
                        Image("search")
                            .resizable()
                            .frame(width: 31, height: 31)
                            .padding(.trailing, 9)
                    }
                }
                .padding()
                .frame(width: UIScreen.main.bounds.width, height: 75, alignment: .bottomLeading)
                .background(Color.searchTop.opacity(0.2))
            }
            .background(Image("BlurSearchBG")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea()
            )
            .navigationDestination(isPresented: $navigateToMainView) {
                MainView()
                    .environmentObject(weatherVM)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    SearchView()
        .environmentObject(WeatherViewModel())
}


struct PlaceholderTextFieldStyle: TextFieldStyle {
    let placeholder: String
    @Binding var text: String

    init(_ placeholder: String, text: Binding<String>) {
        self.placeholder = placeholder
        self._text = text
    }

    func _body(configuration: TextField<Self._Label>) -> some View {
        ZStack(alignment: .leading) {
            if text.isEmpty {
                Text(placeholder)
            }
            configuration
        }
        .foregroundColor(.searchfont)
        .font(.system(size: 20, weight: .regular))
    }
}

