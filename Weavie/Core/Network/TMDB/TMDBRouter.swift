//
//  TMDBRouter.swift
//  Weavie
//
//  Created by 정인선 on 1/24/25.
//

import Foundation
import Alamofire

enum TMDBRouter {
    case trending
    case search(_ searchParam: SearchParam)
    case image(id: Int)
    case credit(id: Int)
    
    var url: String {
        switch self {
        case .trending:
            return "\(APIURL.TMDB_URL)trending/movie/day"
        case .search:
            return "\(APIURL.TMDB_URL)search/movie"
        case .image(let id):
            return "\(APIURL.TMDB_URL)movie/\(id)/images"
        case .credit(let id):
            return "\(APIURL.TMDB_URL)movie/\(id)/credits"
        }
    }
    
    var method: HTTPMethod {
        return .get
    }
        
    var parameters: Parameters? {
        switch self {
        case .trending:
            return TrendParam().toParameters
        case .search(let searchParam):
            return searchParam.toParameters
        case .image:
            return nil
        case .credit:
            return CreditParam().toParameters
        }
    }
    
    var header: HTTPHeaders {
        return ["Authorization": "Bearer \(APIKEY.TMDB_KEY)"]
    }
}

struct TrendParam: Encodable {
    let language: String = "ko-KR"
    let page: Int = 1
}

struct SearchParam: Encodable {
    var query: String = ""
    let includeAdult: Bool = false
    let language: String = "ko-KR"
    var page: Int = 1
    
    enum CodingKeys: String, CodingKey {
        case query
        case includeAdult = "include_adult"
        case language
        case page
    }
}

struct CreditParam: Encodable {
    let language: String = "ko-KR"
}
