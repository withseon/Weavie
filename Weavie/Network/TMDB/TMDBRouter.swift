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
    case search(query: String, page: Int)
    case Image(id: Int)
    case credit(id: Int)
    
    var url: String {
        switch self {
        case .trending:
            return "\(APIURL.TMDB_URL)trending/movie/day"
        case .search:
            return "\(APIURL.TMDB_URL)search/movie"
        case .Image(let id):
            return "\(APIURL.TMDB_URL)movie/\(id)/images"
        case .credit(let id):
            return "\(APIURL.TMDB_URL)movie/\(id)/credits"
        }
    }
    
    var method: HTTPMethod {
        return .get
    }
        
    var parameters: Parameters? {
        let languageParam: Parameters = ["language": "ko-KR"]
        switch self {
        case .trending:
            return languageParam.merging(["page": 1]) { value, _ in value }
        case .search(let query, let page):
            return languageParam.merging(["include_adult": false,
                                          "query": query,
                                          "page": page]) { value, _ in value}
        case .Image(_):
            return nil
        case .credit(_):
            return languageParam
        }
    }
    
    var header: HTTPHeaders {
        return ["Authorization": "Bearer \(APIKEY.TMDB_KEY)"]
    }
}

//struct TrendParam: Encodable {
//    let language: String
//    let page: Int
//}
//
//struct SearchParam: Encodable {
//    let query: String
//    let includeAdult: Bool
//    let language: String
//    let page: Int
//    
//    enum CodingKeys: String, CodingKey {
//        case query
//        case includeAdult = "include_adult"
//        case language
//        case page
//    }
//}
//
//struct CreditParam: Encodable {
//    let language: String
//}
