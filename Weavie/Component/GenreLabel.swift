//
//  GenreLabel.swift
//  Weavie
//
//  Created by 정인선 on 1/28/25.
//

import UIKit
import SnapKit

final class GenreLabel: UILabel {
    private let padding = UIEdgeInsets(top: 2, left: 4, bottom: 2, right: 4)
    
    init(text: String) {
        super.init(frame: .zero)
        self.text = text
        textColor = .mainLabel
        backgroundColor = .subLabel
        font = .systemFont(ofSize: 12)
        clipsToBounds = true
        layer.cornerRadius = 5
    }
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }
    
    override var intrinsicContentSize: CGSize {
        var size = super.intrinsicContentSize
        size.height += padding.top + padding.bottom
        size.width += padding.left + padding.right
        return size
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
