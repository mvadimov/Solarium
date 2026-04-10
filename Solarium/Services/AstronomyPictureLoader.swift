//
//  AstronomyPictureLoader.swift
//  Solarium
//
//  Created by Mark Vadimov on 31.03.26.
//

import Foundation

protocol AstronomyPictureLoading {
    func loadAstronomyPicture(handler: @escaping (Result<[AstronomyPictureModel], Error>) -> Void)
}

struct AstronomyPictureLoader: AstronomyPictureLoading {
    private let networkClient: NetworkRouting
    
    init(networkClient: NetworkRouting = NetworkClient()) {
        self.networkClient = networkClient
    }
    
    private var astronomyPictureURL: URL {
        guard let url = URL(string: "https://api.nasa.gov/planetary/apod?api_key=\(apiKey)&count=7") else {
            preconditionFailure("Unable to construct astronomyPictureURL")
        }
        return url
    }
    
    func loadAstronomyPicture(handler: @escaping (Result<[AstronomyPictureModel], any Error>) -> Void) {
        networkClient.fetch(url: astronomyPictureURL, handler: { result in
            switch result {
            case .success(let data):
                do {
                    let astronomyPicture = try JSONDecoder().decode([AstronomyPictureModel].self, from: data)
                    handler(.success(astronomyPicture))
                } catch {
                    handler(.failure(error))
                }
                
            case .failure(let error):
                handler(.failure(error))
            }
        })
    }
}
