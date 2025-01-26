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
            let imageSize = CGSize(width: bounds.width * 2, height: bounds.height * 2)
            let processor = DownsamplingImageProcessor(size: imageSize)
            kf.indicatorType = .activity
            kf.setImage(with: imageURL,
                        options: [.processor(processor),
                                  .transition(.fade(1))])
        }
    }
}
