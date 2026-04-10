//
//  MarsWeatherModel.swift
//  Solarium
//
//  Created by Mark Vadimov on 31.03.26.
//

struct MarsWeatherModel: Identifiable {
    var id: Int {solNum}
    var solNum: Int
    var tempeture: Double
    var windSpeed: Double
    var pressure: Double
    var season: String
}
