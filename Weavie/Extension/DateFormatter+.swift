//
//  DateFormatter+.swift
//  Weavie
//
//  Created by 정인선 on 1/26/25.
//

import Foundation

extension DateFormatter {
    static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = .init(identifier: "ko_KR")
        return dateFormatter
    }()
}
