//
//  ProfileImageView.swift
//  Weavie
//
//  Created by 정인선 on 1/26/25.
//

import UIKit
import SnapKit

final class ProfileImageView: BaseView {
    private let profileImageView = UIImageView()
    private let cameraCoverView = UIView()
    private let cameraImageView = UIImageView()
    
    override func layoutSubviews() {
        profileImageView.layer.cornerRadius = self.frame.width / 2
        cameraCoverView.layer.cornerRadius = self.frame.width * 3 / 20
    }
    
    override func configureHierarchy() {
        addSubview(profileImageView)
        addSubview(cameraCoverView)
        cameraCoverView.addSubview(cameraImageView)
    }
    
    override func configureLayout() {
        profileImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        cameraCoverView.snp.makeConstraints { make in
            make.size.equalToSuperview().multipliedBy(0.3)
            make.bottom.trailing.equalToSuperview()
        }
        cameraImageView.snp.makeConstraints { make in
            make.size.equalToSuperview().multipliedBy(0.7)
            make.center.equalToSuperview()
        }
    }
    
    override func configureView() {
        backgroundColor = .clear
        profileImageView.backgroundColor = .mainBackground
        profileImageView.clipsToBounds = true
        profileImageView.contentMode = .scaleAspectFit
        
        cameraCoverView.backgroundColor = .tint
        cameraImageView.clipsToBounds = true
        cameraImageView.image = UIImage(systemName: "camera.fill")
        cameraImageView.contentMode = .scaleAspectFit
        cameraImageView.tintColor = .mainLabel
    }
}

extension ProfileImageView {
    func setProfileImage(image: String) {
        profileImageView.image = UIImage(named: image)
    }
    
    func setState(isMain: Bool) {
        if isMain {
            profileImageView.layer.borderColor = UIColor.tint.cgColor
            profileImageView.layer.borderWidth = 3
            profileImageView.alpha = 1
        } else {
            profileImageView.layer.borderColor = UIColor.subLabel.cgColor
            profileImageView.layer.borderWidth = 1
            profileImageView.alpha = 0.5
        }
    }
    
    func hiddenCameraImage(isHidden: Bool) {
        cameraCoverView.isHidden = isHidden
    }
}
