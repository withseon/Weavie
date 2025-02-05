//
//  RecentSearchCollectionViewCell.swift
//  Weavie
//
//  Created by 정인선 on 1/25/25.
//

import UIKit
import SnapKit

final class RecentSearchCollectionViewCell: BaseCollectionViewCell {
    private let searchLabel = UILabel()
    private let xmarkImageView = UIImageView()
    
    override func configureHierarchy() {
        contentView.addSubview(searchLabel)
        contentView.addSubview(xmarkImageView)
    }
    
    override func configureLayout() {
        searchLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(12)
            make.centerY.equalToSuperview()
        }
        xmarkImageView.snp.makeConstraints { make in
            make.leading.equalTo(searchLabel.snp.trailing).offset(4)
            make.centerY.equalToSuperview()
            make.size.equalTo(15)
            make.trailing.equalToSuperview().inset(12)
        }
    }
    
    override func configureView() {
        contentView.backgroundColor = .tertiaryBackground
        contentView.layer.cornerRadius = self.frame.height / 2
        
        searchLabel.textColor = .mainBackground
        searchLabel.font = .systemFont(ofSize: 14)
        
        xmarkImageView.image = UIImage(systemName: "xmark")
        xmarkImageView.contentMode = .scaleAspectFit
        xmarkImageView.tintColor = .mainBackground
    }
}

extension RecentSearchCollectionViewCell {
    func configureContent(text: String) {
        searchLabel.text = text
    }
    
    func setupXmark(tag: Int, gesture: UIGestureRecognizer) {
        xmarkImageView.tag = tag
        xmarkImageView.isUserInteractionEnabled = true
        xmarkImageView.addGestureRecognizer(gesture)
    }
}
