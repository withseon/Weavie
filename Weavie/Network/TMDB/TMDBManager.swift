//
//  TMDBManager.swift
//  Weavie
//
//  Created by 정인선 on 1/24/25.
//

import Foundation
/*
 1    200    Success.
 2    501    Invalid service: this service does not exist.
 3    401    Authentication failed: You do not have permissions to access the service.
 4    405    Invalid format: This service doesn't exist in that format.
 5    422    Invalid parameters: Your request parameters are incorrect.
 6    404    Invalid id: The pre-requisite id is invalid or not found.
 7    401    Invalid API key: You must be granted a valid key.
 8    403    Duplicate entry: The data you tried to submit already exists.
 9    503    Service offline: This service is temporarily offline, try again later.
 10    401    Suspended API key: Access to your account has been suspended, contact TMDB.
 11    500    Internal error: Something went wrong, contact TMDB.
 */

enum TMDBERROR: Error {
    case invalidService
    case authenticationFailed
    case invalidFormat
    case invalidParameters
    case invalidID
    case duplicateEntry
    case serviceOffline
    case internalError
    case unknown
    
    var message: String {
        switch self {
        case .invalidService:
            return "this service does not exist."
        case .authenticationFailed:
            return "You do not have permissions to access the service."
        case .invalidFormat:
            return "This service doesn't exist in that format."
        case .invalidParameters:
            return "Your request parameters are incorrect."
        case .invalidID:
            return "The pre-requisite id is invalid or not found."
        case .duplicateEntry:
            return "The data you tried to submit already exists."
        case .serviceOffline:
            return "This service is temporarily offline, try again later."
        case .internalError:
            return "Something went wrong, contact TMDB."
        case .unknown:
            return "unknown error."
        }
    }
}

enum TMDBManager {
    static func executeFetch<T: Decodable>(api: TMDBRouter, type: T.Type, completion: @escaping (Result<T, TMDBERROR>) -> Void) {
        NetworkManager.networkRequest(url: api.url,
                                      method: api.method,
                                      parameters: api.parameters,
                                      headers: api.header,
                                      type: T.self) { result in
            switch result {
            case .success(let value):
                completion(.success(value))
            case .failure(let error):
                guard let statusCode = error.responseCode else { return }
                let tmdbError = getTMDBError(statusCode: statusCode)
                completion(.failure(tmdbError))
            }
        }
    }
}

extension TMDBManager {
    static func getTMDBError(statusCode: Int) -> TMDBERROR {
        switch statusCode {
        case 401:
            return .authenticationFailed
        case 403:
            return .duplicateEntry
        case 404:
            return .invalidID
        case 405:
            return .invalidFormat
        case 422:
            return .invalidParameters
        case 500:
            return .internalError
        case 501:
            return .invalidService
        case 503:
            return .serviceOffline
        default:
            return .unknown
        }
    }
}
