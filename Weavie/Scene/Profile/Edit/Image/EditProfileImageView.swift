//
//  EditProfileImageView.swift
//  Weavie
//
//  Created by 정인선 on 1/31/25.
//

import UIKit
import SnapKit

final class EditProfileImageView: BaseView {
    private let mainProfileImageView = ProfileImageView(isCameraImage: true)
    let profileImageCollectionView = UICollectionView(frame: .zero, collectionViewLayout: profileImageCollectionViewLayout())
    
    override func configureHierarchy() {
        addSubview(mainProfileImageView)
        addSubview(profileImageCollectionView)
    }
    
    override func configureLayout() {
        mainProfileImageView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).inset(20)
            make.centerX.equalToSuperview()
            make.size.equalTo(100)
        }
        profileImageCollectionView.snp.makeConstraints { make in
            make.top.equalTo(mainProfileImageView.snp.bottom).offset(40)
            make.bottom.horizontalEdges.equalToSuperview()
        }
    }
    
    override func configureView() {
        mainProfileImageView.setState(isMain: true)
        profileImageCollectionView.backgroundColor = .clear
    }
}

extension EditProfileImageView {
    func setProfileImageView(profileImageIndex: Int) {
        mainProfileImageView.setProfileImage(image: Resource.AssetImage.profile(profileImageIndex).path)
    }
}

extension EditProfileImageView {
    static func profileImageCollectionViewLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        let sectionSpacing: CGFloat = 20
        let itemSpacing: CGFloat = 10
        let width = (UIScreen.main.bounds.width - (sectionSpacing * 2) - (itemSpacing * 3)) / 4
        layout.itemSize = CGSize(width: width, height: width)
        layout.sectionInset = UIEdgeInsets(top: 0, left: sectionSpacing, bottom: 0, right: sectionSpacing)
        layout.scrollDirection = .vertical
        return layout
    }
}
