//
//  MovieImage.swift
//  Weavie
//
//  Created by 정인선 on 1/24/25.
//

import Foundation

// Images API
struct MovieImage: Decodable {
    let id: Int
    let backdrops: [ImageInfo]
    let posters: [ImageInfo]
}

struct ImageInfo: Decodable {
    let filePath: String
    
    enum CodingKeys: String, CodingKey {
        case filePath = "file_path"
    }
}
