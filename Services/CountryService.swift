//
//  CountryService.swift
//  weather
//
//  Created by chandana on 26/07/24.
//

import Foundation

// api that converts country code to country name
class CountryService {
    func getCountryName(from countryCode: String, completion: @escaping (String) -> Void) {
        guard let url = URL(string: "https://restcountries.com/v3.1/alpha/\(countryCode)") else {
            completion("Unknown Country")
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion("Unknown Country")
                return
            }

            let countryResponse = try? JSONDecoder().decode([Country].self, from: data)
            if let country = countryResponse?.first {
                completion(country.name.common)
            } else {
                completion("Unknown Country")
            }
        }.resume()
    }
}

struct Country: Decodable {
    let name: CountryName
}

struct CountryName: Decodable {
    let common: String
}
