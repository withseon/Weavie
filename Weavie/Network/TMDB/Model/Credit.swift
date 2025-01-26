//
//  Credit.swift
//  Weavie
//
//  Created by 정인선 on 1/24/25.
//

import Foundation

// TODO: nill 대응
struct Credit: Decodable {
    let id: Int
    let cast: [Cast]?
}

struct Cast: Decodable {
    let name: String
    let character: String
    let profilePath: String?
    
    enum CodingKeys: String, CodingKey {
        case name
        case character
        case profilePath = "profile_path"
    }
}
