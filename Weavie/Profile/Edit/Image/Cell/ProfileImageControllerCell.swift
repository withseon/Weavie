//
//  ProfileImageControllerCell.swift
//  Weavie
//
//  Created by 정인선 on 1/31/25.
//

import UIKit
import SnapKit

final class ProfileImageControllerCell: BaseCollectionViewCell {
    private let profileImageView = ProfileImageView()
    
    override var isSelected: Bool {
        willSet {
            profileImageView.setState(isMain: newValue)
        }
    }
    
    override func configureHierarchy() {
        contentView.addSubview(profileImageView)
    }
    
    override func configureLayout() {
        profileImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func configureView() {
        profileImageView.hiddenCameraImage(isHidden: true)
        profileImageView.setState(isMain: false)
    }
}

extension ProfileImageControllerCell {
    func configureContent(imageIndex: Int) {
        profileImageView.setProfileImage(image: Resource.AssetImage.profile(imageIndex).path)
    }
}
