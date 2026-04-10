//
//  AstronomyPictureModel.swift
//  Solarium
//
//  Created by Mark Vadimov on 31.03.26.
//

import Foundation

struct AstronomyPictureModel: Codable {
    let copyright: String?
    let date: String
    let explanation: String?
    let media_type: String?
    let title: String?
    let url: URL
    var id: String {date}
    
    var resizedImageURL: URL {
        let urlString = url.absoluteString
        let imageUrlString = urlString
        guard let newURL = URL(string: imageUrlString) else {
            return url
        }
        return newURL
    }
}
