//
//  RoundBorderButton.swift
//  Weavie
//
//  Created by 정인선 on 1/24/25.
//

import UIKit
import SnapKit

final class RoundBorderButton: UIButton {
    init(title: String) {
        super.init(frame: .zero)
        var config = UIButton.Configuration.plain()
        config.cornerStyle = .capsule
        config.title = title
        config.baseForegroundColor = .tint
        config.baseBackgroundColor = .clear
        config.background.strokeColor = .tint
        config.background.strokeWidth = 2
        config.contentInsets = ConstraintDirectionalInsets(top: 12, leading: 0, bottom: 12, trailing: 0)
        
        configuration = config
    }
    
    override var isEnabled: Bool {
        willSet {
            configuration?.background.strokeColor = newValue ? .tint : .subLabel
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
