//
//  PosterCollectionViewCell.swift
//  Weavie
//
//  Created by 정인선 on 1/29/25.
//

import UIKit
import SnapKit

final class PosterCollectionViewCell: BaseCollectionViewCell {
    private let posterImageView = UIImageView()
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    override func configureHierarchy() {
        contentView.addSubview(posterImageView)
    }
    
    override func configureLayout() {
        posterImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func configureView() {
        posterImageView.backgroundColor = .systemGray
        posterImageView.contentMode = .scaleAspectFill
        posterImageView.clipsToBounds = true
    }
}

extension PosterCollectionViewCell {
    func configureContent(filePath: String) {
        let url = TMDBManager.getImageURL(type: .subPoster, filePath: filePath)
        posterImageView.setKFImage(strURL: url)
    }
}
