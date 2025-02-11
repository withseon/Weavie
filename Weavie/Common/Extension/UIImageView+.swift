//
//  UIImageView+.swift
//  Weavie
//
//  Created by 정인선 on 1/25/25.
//

import UIKit
import Kingfisher

extension UIImageView {
    func setKFImage(strURL: String) {
        if let imageURL = URL(string: strURL) {
            kf.indicatorType = .activity
            kf.setImage(with: imageURL,
                        options: [.transition(.fade(1))])
        }
    }
}
