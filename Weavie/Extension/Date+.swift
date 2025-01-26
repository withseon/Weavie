//
//  Date+.swift
//  Weavie
//
//  Created by 정인선 on 1/26/25.
//

import Foundation

extension Date {
    func toFormattedString(_ dateFormat: String = "yyyy-MM-dd(EEEEE) a HH:mm") -> String? {
        let dateFormatter = DateFormatter.dateFormatter
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.string(from: self)
    }
}
