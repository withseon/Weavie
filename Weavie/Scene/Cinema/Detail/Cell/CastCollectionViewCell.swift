//
//  CastCollectionViewCell.swift
//  Weavie
//
//  Created by 정인선 on 1/29/25.
//

import UIKit
import SnapKit

final class CastCollectionViewCell: BaseCollectionViewCell {
    private let profileImageView = UIImageView()
    private let stackView = UIStackView()
    private let nameLabel = UILabel()
    private let characterLabel = UILabel()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        profileImageView.image = nil
        nameLabel.text = "Name"
        characterLabel.text = "character"
    }
    
    override func configureHierarchy() {
        contentView.addSubview(profileImageView)
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(characterLabel)
    }
    
    override func configureLayout() {
        profileImageView.snp.makeConstraints { make in
            make.leading.verticalEdges.equalToSuperview()
            make.width.equalTo(profileImageView.snp.height)
        }
        stackView.snp.makeConstraints { make in
            make.leading.equalTo(profileImageView.snp.trailing).offset(8)
            make.centerY.equalTo(profileImageView)
            make.trailing.equalToSuperview().inset(12)
        }
    }
    
    override func configureView() {
        profileImageView.backgroundColor = .systemGray
        profileImageView.clipsToBounds = true
        profileImageView.layer.cornerRadius = self.frame.height / 2
        profileImageView.contentMode = .scaleAspectFill
        
        stackView.axis = .vertical
        stackView.spacing = 4
        
        nameLabel.font = .systemFont(ofSize: 13, weight: .semibold)
        nameLabel.textColor = .mainLabel
        
        characterLabel.font = .systemFont(ofSize: 12)
        characterLabel.textColor = .subLabel
    }
}

extension CastCollectionViewCell {
    func configureContent(cast: Cast) {
        if cast.profilePath != "unknown" {
            let url = TMDBManager.getImageURL(type: .credit, filePath: cast.profilePath)
            profileImageView.setKFImage(strURL: url)
        }
        nameLabel.text = cast.name
        characterLabel.text = cast.character
    }
}
