//
//  MarsWeatherModel.swift
//  Solarium
//
//  Created by Mark Vadimov on 31.03.26.
//

import Foundation

struct MarsWeatherAPI: Codable {
    let solKeys: [String]
    var sols: [String: SolData] = [:]
    
    enum CodingKeys: String, CodingKey {
        case solKeys = "sol_keys"
    }
}

struct SolData: Codable {
    let at: TemperatureData
    let firstUTC: String
    let hws: WindSpeedData
    let lastUTC: String
    let pre: PressureData
    let season: String
    
    enum CodingKeys: String, CodingKey {
        case at = "AT"
        case firstUTC = "First_UTC"
        case hws = "HWS"
        case lastUTC = "Last_UTC"
        case pre = "PRE"
        case season = "Season"
    }
}

struct TemperatureData: Codable {
    let av: Double
    let mn: Double
    let mx: Double
}

struct WindSpeedData: Codable {
    let av: Double
    let mx: Double
}

struct PressureData: Codable {
    let av: Double
}
