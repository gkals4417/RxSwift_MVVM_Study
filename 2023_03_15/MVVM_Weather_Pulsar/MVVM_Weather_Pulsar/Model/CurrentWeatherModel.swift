//
//  CurrentWeatherModel.swift
//  MVVM_Weather_Pulsar
//
//  Created by Hamin Jeong on 2023/03/09.
//
// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? JSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

// MARK: - Welcome
struct CurrentWelcome: Codable {
    let coord: CurrentCoord
    let weather: [CurrentWeather]
    let base: String
    let main: CurrentMain
    let visibility: Int
    let wind: CurrentWind
    let clouds: CurrentClouds
    let dt: Int
    let sys: CurrentSys
    let timezone, id: Int
    let name: String
    let cod: Int
}

// MARK: - Clouds
struct CurrentClouds: Codable {
    let all: Int
}

// MARK: - Coord
struct CurrentCoord: Codable {
    let lon, lat: Double
}

// MARK: - Main
struct CurrentMain: Codable {
    let temp, feelsLike, tempMin, tempMax: Double
    let pressure, humidity: Int

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure, humidity
    }
}

// MARK: - Sys
struct CurrentSys: Codable {
    let type, id: Int
    let country: String
    let sunrise, sunset: Int
}

// MARK: - Weather
struct CurrentWeather: Codable {
    let id: Int
    let main, description, icon: String
}

// MARK: - Wind
struct CurrentWind: Codable {
    let speed: Double
    let deg: Int
}


