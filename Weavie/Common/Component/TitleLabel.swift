//
//  TitleLabel.swift
//  Weavie
//
//  Created by 정인선 on 1/25/25.
//

import UIKit

final class TitleLabel: UILabel {
    init(text: String) {
        super.init(frame: .zero)
        font = .systemFont(ofSize: 16, weight: .bold)
        textColor = .mainLabel
        self.text = text
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
