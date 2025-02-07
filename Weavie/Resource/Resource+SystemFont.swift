//
//  Resource+SystemFont.swift
//  Weavie
//
//  Created by 정인선 on 2/7/25.
//

import UIKit

// MARK: - 폰트
extension Resource {
    enum SystemFont {
        static let regular12: UIFont = .systemFont(ofSize: 12)
        static let regular13: UIFont = .systemFont(ofSize: 13)
        static let regular14: UIFont = .systemFont(ofSize: 14)
        static let regular15: UIFont = .systemFont(ofSize: 15)
        static let regular16: UIFont = .systemFont(ofSize: 16)
        
        static let semibold12: UIFont = .systemFont(ofSize: 12, weight: .semibold)
        static let semibold13: UIFont = .systemFont(ofSize: 13, weight: .semibold)
        static let semibold14: UIFont = .systemFont(ofSize: 14, weight: .semibold)
        static let semibold15: UIFont = .systemFont(ofSize: 15, weight: .semibold)
        static let semibold16: UIFont = .systemFont(ofSize: 16, weight: .semibold)
        
        static let bold12: UIFont = .systemFont(ofSize: 12, weight: .bold)
        static let bold13: UIFont = .systemFont(ofSize: 13, weight: .bold)
        static let bold14: UIFont = .systemFont(ofSize: 14, weight: .bold)
        static let bold15: UIFont = .systemFont(ofSize: 15, weight: .bold)
        static let bold16: UIFont = .systemFont(ofSize: 16, weight: .bold)
        
        static let heavy30: UIFont = .systemFont(ofSize: 30, weight: .heavy)
    }
}
