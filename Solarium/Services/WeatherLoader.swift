//
//  WeatherLoader.swift
//  Solarium
//
//  Created by Mark Vadimov on 31.03.26.
//

import Foundation

protocol WeatherLoading {
    func loadWeather(handler: @escaping (Result<MarsWeatherAPI, Error>) -> Void)
}

struct WeatherLoader: WeatherLoading {
    private let networkClient: NetworkRouting
    
    init(networkClient: NetworkRouting = NetworkClient()) {
        self.networkClient = networkClient
    }
    
    private var marsWeatherURL: URL {
        guard let url = URL(string: "https://api.nasa.gov/insight_weather/?api_key=\(apiKey)&feedtype=json&ver=1.0") else {
            preconditionFailure("Unable to construct marsWeatherURL")
        }
        return url
    }
    
    func loadWeather(handler: @escaping (Result<MarsWeatherAPI, Error>) -> Void) {
        networkClient.fetch(url: marsWeatherURL) { result in
            switch result {
            case .success(let data):
                do {
                    let marsWeather = try decodeMarsWeather(from: data)
                    handler(.success(marsWeather))
                } catch {
                    handler(.failure(error))
                }
                
            case .failure(let error):
                handler(.failure(error))
            }
        }
    }
    
    private func decodeMarsWeather(from data: Data) throws -> MarsWeatherAPI {
        guard let jsonObject = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            throw NSError(domain: "WeatherLoader", code: 1, userInfo: [
                NSLocalizedDescriptionKey: "Invalid JSON structure"
            ])
        }
        
        guard let solKeys = jsonObject["sol_keys"] as? [String] else {
            throw NSError(domain: "WeatherLoader", code: 2, userInfo: [
                NSLocalizedDescriptionKey: "Missing sol_keys"
            ])
        }
        
        var sols: [String: SolData] = [:]
        let decoder = JSONDecoder()
        
        for key in solKeys {
            guard let solObject = jsonObject[key] as? [String: Any] else {
                continue
            }
            
            guard !solObject.isEmpty else {
                continue
            }
            
            let solData = try JSONSerialization.data(withJSONObject: solObject)
            let decodedSol = try decoder.decode(SolData.self, from: solData)
            sols[key] = decodedSol
        }
        
        return MarsWeatherAPI(solKeys: solKeys, sols: sols)
    }
}

func loadData() {
    let weatherLoader = WeatherLoader()
    let astrnomyLoader = AstronomyPictureLoader()
    
    weatherLoader.loadWeather { result in
        switch result {
        case .success(let marsWeather):
            print(marsWeather)
        case .failure(let error):
            print("Failed to load weather: \(error)")
        }
    }
    
    astrnomyLoader.loadAstronomyPicture{ result in
        switch result {
        case .success(let astrnomyPicture):
            print(astrnomyPicture)
        case .failure(let error):
            print("Failed to load Astronomy Pictures: \(error)")
        }
    }
}
