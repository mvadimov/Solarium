//
//  AstronomyPictureViewModel.swift
//  Solarium
//
//  Created by Mark Vadimov on 31.03.26.
//

import SwiftUI
import Combine

class AstronomyPictureViewModel: ObservableObject {
    @Published var astronomy = [LoadedAstronomyPicture]()
    @Published var isLoadedAP: Bool = false
    @Published var selectedAstronomy: LoadedAstronomyPicture?
    
    private let astronomyPictureLoader: AstronomyPictureLoading
    
    init() {
        self.astronomyPictureLoader = AstronomyPictureLoader()
    }
    
    func loadData() {
        guard !isLoadedAP else { return }
        astronomyPictureLoader.loadAstronomyPicture(handler: { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let astronomy):
                    self?.convertData(from: astronomy) { loadedPictures in
                        self?.astronomy = loadedPictures
                    }
                    self?.isLoadedAP = true
                case .failure(let error):
                    print("Failed to load astronomy picture: \(error)")
                }
            }
        })
    }
    
    func convertData(from data: [AstronomyPictureModel], completion: @escaping ([LoadedAstronomyPicture]) -> Void) {
        var convertedData = [LoadedAstronomyPicture]()
        let group = DispatchGroup()
        let queue = DispatchQueue(label: "com.syncQueue")
        
        for item in data {
            group.enter()
            returnImage(picture: item) { imageData, error in
                defer { group.leave() }
                
                if let error = error {
                    print("Failed to load image: \(error)")
                    return
                }
                
                if let imageData = imageData, let image = UIImage(data: imageData) {
                    let loadedPicture = LoadedAstronomyPicture(
                        model: item,
                        image: image,
                    )
                    queue.async {
                        convertedData.append(loadedPicture)
                    }
                }
            }
        }
        
        group.notify(queue: .main) {
            completion(convertedData)
        }
    }
    
    func returnImage(picture: AstronomyPictureModel, completion: @escaping (Data?, Error?) -> Void) {
        DispatchQueue.global().async {
            do {
                let imageData = try Data(contentsOf: picture.resizedImageURL)
                DispatchQueue.main.async {
                    completion(imageData, nil)
                }
            } catch {
                print("Failed to load image: \(error)")
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
    }
}
