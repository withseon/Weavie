//
//  String+.swift
//  Weavie
//
//  Created by 정인선 on 1/29/25.
//

import Foundation

extension String {
    func toDate(_ dateFormat: String = "yyyy-MM-dd(EEEEE) a HH:mm") -> Date? {
        let dateFormatter = DateFormatter.dateFormatter
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.date(from: self)
    }
}
