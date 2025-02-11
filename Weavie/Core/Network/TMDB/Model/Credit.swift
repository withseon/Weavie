//
//  Credit.swift
//  Weavie
//
//  Created by 정인선 on 1/24/25.
//

import Foundation

struct Credit: Decodable {
    let id: Int
    let cast: [Cast]
    
    enum CodingKeys: String, CodingKey {
        case id
        case cast
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.cast = try container.decodeIfPresent([Cast].self, forKey: .cast) ?? []
    }
}

struct Cast: Decodable {
    let name: String
    let character: String
    let profilePath: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case character
        case profilePath = "profile_path"
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.character = try container.decode(String.self, forKey: .character)
        self.profilePath = try container.decodeIfPresent(String.self, forKey: .profilePath) ?? "unknown"
    }
}
