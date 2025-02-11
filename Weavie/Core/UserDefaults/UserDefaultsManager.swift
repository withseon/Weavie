//
//  UserDefaultsManager.swift
//  Weavie
//
//  Created by 정인선 on 1/25/25.
//

import Foundation

struct UserDefaultsManager {
    @UserDefaultWrapper(key: "USER", defaultValue: nil)
    static var user: User?
    
    @UserDefaultWrapper(key: "LIKED_MOVIE", defaultValue: nil)
    static var likedMovies: Set<Int>?
    
    @UserDefaultWrapper(key: "SEARCH_RECORD", defaultValue: nil)
    static var searchRecord: [String: Date]?
}

@propertyWrapper
struct UserDefaultWrapper<T: Codable> {
    let key: String
    let defaultValue: T?
    
    init(key: String, defaultValue: T?) {
        self.key = key
        self.defaultValue = defaultValue
    }
    
    var wrappedValue: T? {
        get {
            if let savedData = UserDefaults.standard.object(forKey: key) as? Data {
                let decoder = JSONDecoder()
                if let savedObject = try? decoder.decode(T.self, from: savedData) {
                    return savedObject
                }
            }
            return defaultValue
        }
        set {
            if let newValue {
                let encoder = JSONEncoder()
                if let encoded = try? encoder.encode(newValue) {
                    UserDefaults.standard.set(encoded, forKey: key)
                }
            } else {
                UserDefaults.standard.removeObject(forKey: key)
            }
        }
    }
}
