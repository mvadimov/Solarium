//
//  MarsWeatherViewModel.swift
//  Solarium
//
//  Created by Mark Vadimov on 31.03.26.
//

import Foundation
import Combine

class MarsWeatherViewModel: ObservableObject {
    @Published var weather = MarsWeatherAPI(solKeys: [], sols: [:])
    @Published var isLoading = false
    @Published var isLoadedMW = false
    @Published var errorMessage: String?
    
    private let marsWeatherLoader: WeatherLoading
    
    init() {
        self.marsWeatherLoader = WeatherLoader()
    }
    
    func loadData() {
        guard !isLoading else { return }
        guard !isLoadedMW else { return }
        
        isLoading = true
        errorMessage = nil
        
        marsWeatherLoader.loadWeather(handler: { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                switch result {
                case .success(let weather):
                    self?.weather = weather
                    self?.isLoadedMW = true
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                    print("Failed to load weather: \(error)")
                }
            }
        })
    }
}
