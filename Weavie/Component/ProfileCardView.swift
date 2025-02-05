//
//  ProfileCardView.swift
//  Weavie
//
//  Created by 정인선 on 1/25/25.
//

import UIKit
import SnapKit

final class ProfileCardView: BaseView {
    private let profileImageView = ProfileImageView()
    private let labelStackView = UIStackView()
    private let nicknameLabel = UILabel()
    private let registerDateLabel = UILabel()
    private let chevronButton = UIButton()
    private let movieboxButton = UIButton()
    
    override func configureHierarchy() {
        addSubview(profileImageView)
        addSubview(labelStackView)
        labelStackView.addArrangedSubview(nicknameLabel)
        labelStackView.addArrangedSubview(registerDateLabel)
        addSubview(chevronButton)
        addSubview(movieboxButton)
    }
    
    override func configureLayout() {
        profileImageView.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().inset(12)
            make.size.equalTo(44)
        }
        labelStackView.snp.makeConstraints { make in
            make.centerY.equalTo(profileImageView)
            make.leading.equalTo(profileImageView.snp.trailing).offset(12)
        }
        chevronButton.snp.makeConstraints { make in
            make.centerY.equalTo(profileImageView)
            make.leading.greaterThanOrEqualTo(labelStackView.snp.trailing).offset(12)
            make.trailing.equalToSuperview().inset(12)
        }
        movieboxButton.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(12)
            make.bottom.horizontalEdges.equalToSuperview().inset(12)
            make.height.equalTo(30)
        }
    }
    
    override func configureView() {
        backgroundColor = .secondaryBackground
        layer.cornerRadius = 10
        
        profileImageView.setState(isMain: true)
        profileImageView.hiddenCameraImage(isHidden: true)
        
        labelStackView.axis = .vertical
        labelStackView.distribution = .fill
        labelStackView.spacing = 4
        
        nicknameLabel.font = .systemFont(ofSize: 16, weight: .bold)
        nicknameLabel.text = "NICKNAMENICKNAMENICKNAMENICKNAME"
        nicknameLabel.textColor = .mainLabel
        
        registerDateLabel.font = .systemFont(ofSize: 12)
        registerDateLabel.text = "yy.MM.dd 가입"
        registerDateLabel.textColor = .subLabel
        
        var chevronConfig = UIButton.Configuration.plain()
        chevronConfig.image = UIImage(systemName: "chevron.right")
        chevronConfig.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        chevronConfig.baseForegroundColor = .subLabel
        chevronButton.configuration = chevronConfig
        
        var movieboxConfig = UIButton.Configuration.filled()
        movieboxConfig.attributedTitle = AttributedString("NNN 개의 무비박스 보관중", attributes: AttributeContainer([.font: UIFont.systemFont(ofSize: 14, weight: .semibold)]))
        movieboxConfig.baseBackgroundColor = .tint
        movieboxConfig.baseForegroundColor = .mainLabel
        movieboxConfig.cornerStyle = .medium
        movieboxButton.configuration = movieboxConfig
        movieboxButton.isUserInteractionEnabled = false
    }
}

extension ProfileCardView {
    func configureContent(user: User, likedMovieCount: Int) {
        profileImageView.setProfileImage(imageNum: 0)
    func setUserProfile(user: User) {
        profileImageView.setProfileImage(image: Resource.AssetImage.profile(user.imageIndex).path)
        nicknameLabel.text = user.nickname
        registerDateLabel.text = user.registerDate.toFormattedString("yy년 MM월 dd일 가입")
    }
    
    func setMovieboxButton(likedMovieCount: Int) {
        movieboxButton.configuration?.attributedTitle = AttributedString("\(likedMovieCount)개의 무비박스 보관중", attributes: AttributeContainer([.font: UIFont.systemFont(ofSize: 14, weight: .semibold)]))

    }
}
