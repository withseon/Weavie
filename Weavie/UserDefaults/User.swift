//
//  User.swift
//  Weavie
//
//  Created by 정인선 on 1/25/25.
//

import Foundation

struct User: Codable {
    let nickname: String
    let imageIndex: Int
    let mbti: [Int]
    let registerDate: Date
}
