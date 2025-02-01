//
//  Movie.swift
//  Weavie
//
//  Created by 정인선 on 1/24/25.
//

import Foundation

// Trending API
struct TrendMovie: Decodable {
    let page: Int
    let results: [Movie]
}

// Search API
struct SearchMovie: Decodable {
    let page: Int
    let results: [Movie]
    let totalPages: Int
    let totalResults: Int
    
    enum CodingKeys: String, CodingKey {
        case page
        case results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

struct Movie: Decodable {
    let id: Int
    let backdropPath: String
    let title: String
    let overview: String
    let posterPath: String
    let genreIDs: [Int]
    let releaseDate: String
    let voteAverage: Double
    
    enum CodingKeys: String, CodingKey {
        case id
        case backdropPath = "backdrop_path"
        case title
        case overview
        case posterPath = "poster_path"
        case genreIDs = "genre_ids"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.backdropPath = try container.decodeIfPresent(String.self, forKey: .backdropPath) ?? "unknown"
        self.title = try container.decode(String.self, forKey: .title)
        let overview = try container.decode(String.self, forKey: .overview)
        if overview.isEmpty {
            self.overview = "시놉시스 준비중입니다."
        } else {
            self.overview = overview
        }
        self.posterPath = try container.decodeIfPresent(String.self, forKey: .posterPath) ?? "unknown"
        self.genreIDs = try container.decode([Int].self, forKey: .genreIDs)
        self.releaseDate = try container.decode(String.self, forKey: .releaseDate)
        self.voteAverage = try container.decode(Double.self, forKey: .voteAverage)
    }
}
