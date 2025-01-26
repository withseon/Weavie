//
//  NetworkManager.swift
//  Weavie
//
//  Created by 정인선 on 1/24/25.
//

import Foundation
import Alamofire

enum NetworkManager {
    static func networkRequest<T: Decodable>(url: URLConvertible,
                                             method: HTTPMethod,
                                             parameters: Parameters? = nil,
                                             encoding: ParameterEncoding = URLEncoding(destination: .queryString),
                                             headers: HTTPHeaders? = nil,
                                             type: T.Type,
                                             completion: @escaping (Result<T, AFError>) -> Void) {
        AF.request(url, method: method, parameters: parameters, encoding: encoding,  headers: headers)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: T.self) { response in
                switch response.result {
                case .success(let value):
                    completion(.success(value))
                case .failure(let error):
                    print("❌ NetworkManager: \(error)")
                    completion(.failure(error))
                }
            }
    }
}
