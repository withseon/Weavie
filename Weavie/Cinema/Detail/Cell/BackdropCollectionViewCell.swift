//
//  BackdropCollectionViewCell.swift
//  Weavie
//
//  Created by 정인선 on 1/29/25.
//

import UIKit
import SnapKit

final class BackdropCollectionViewCell: BaseCollectionViewCell {
    private let backdropImageView = UIImageView()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
    
    override func configureHierarchy() {
        contentView.addSubview(backdropImageView)
    }
    
    override func configureLayout() {
        backdropImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func configureView() {
        backdropImageView.backgroundColor = .systemGray
        backdropImageView.contentMode = .scaleAspectFill
        backdropImageView.clipsToBounds = true
    }
}

extension BackdropCollectionViewCell {
    func configureContent(filePath: String) {
//        if let filePath {
            backdropImageView.setKFImage(strURL: "https://image.tmdb.org/t/p/w500\(filePath)")
//        }
    }
}
