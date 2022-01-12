//
//  City.swift
//  WeatherApp
//
//  Created by MZ01-KYONGH on 2022/01/12.
//

import Foundation

struct City: Codable {
    let cityName: String
    let state: Int // 화씨
    let celsius: Double // 섭씨
    let rainfallProbability: Int
    
    var temperature: String {
        return ("섭씨 \(celsius)도, 화씨\(state)도")
    }
    
    var precipitation: String {
        return ("강수확률 \(rainfallProbability)%")
    }
    
    enum CodingKeys: String, CodingKey {
        case state, celsius
        case cityName = "city_name"
        case rainfallProbability = "rainfall_probability"
    }
}
