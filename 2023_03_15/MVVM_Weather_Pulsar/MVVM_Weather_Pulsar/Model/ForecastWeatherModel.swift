//
//  ForecastWeatherModel.swift
//  MVVM_Weather_Pulsar
//
//  Created by Hamin Jeong on 2023/03/09.
// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? JSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

// MARK: - Welcome
struct ForeCastWelcome: Codable {
    let cod: String
    let message, cnt: Int
    let list: [ForeCastList]
    let city: ForeCastCity
}

// MARK: - City
struct ForeCastCity: Codable {
    let id: Int
    let name: String
    let coord: Coord
    let country: String
    let population, timezone, sunrise, sunset: Int
}

// MARK: - Coord
struct ForeCastCoord: Codable {
    let lat, lon: Double
}

// MARK: - List
struct ForeCastList: Codable {
    let dt: Int
    let main: ForeCastMainClass
    let weather: [Weather]
    let clouds: Clouds
    let wind: Wind
    let visibility: Int
    let pop: Double
    let sys: Sys
    let dtTxt: String
    let rain, snow: ForeCastRain?

    enum CodingKeys: String, CodingKey {
        case dt, main, weather, clouds, wind, visibility, pop, sys
        case dtTxt = "dt_txt"
        case rain, snow
    }
}

// MARK: - Clouds
struct ForeCastClouds: Codable {
    let all: Int
}

// MARK: - MainClass
struct ForeCastMainClass: Codable {
    let temp, feelsLike, tempMin, tempMax: Double
    let pressure, seaLevel, grndLevel, humidity: Int
    let tempKf: Double

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure
        case seaLevel = "sea_level"
        case grndLevel = "grnd_level"
        case humidity
        case tempKf = "temp_kf"
    }
}

// MARK: - Rain
struct ForeCastRain: Codable {
    let the3H: Double

    enum CodingKeys: String, CodingKey {
        case the3H = "3h"
    }
}

// MARK: - Sys
struct ForeCastSys: Codable {
    let pod: Pod
}

enum Pod: String, Codable {
    case d = "d"
    case n = "n"
}

// MARK: - Weather
struct ForeCastWeather: Codable {
    let id: Int
    let main: MainEnum
    let description, icon: String
}

enum MainEnum: String, Codable {
    case clear = "Clear"
    case clouds = "Clouds"
    case rain = "Rain"
    case snow = "Snow"
}

// MARK: - Wind
struct ForeCastWind: Codable {
    let speed: Double
    let deg: Int
    let gust: Double
}

