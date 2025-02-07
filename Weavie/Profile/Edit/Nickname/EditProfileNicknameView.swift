//
//  EditProfileNicknameView.swift
//  Weavie
//
//  Created by 정인선 on 1/30/25.
//

import UIKit
import SnapKit

final class EditProfileNicknameView: BaseView {
    private let profileImageView = ProfileImageView(isCameraImage: true)
    let nicknameTextField = UITextField()
    private let lineView = UIView()
    private let nicknameStateLabel = UILabel()
    let doneButton = RoundBorderButton(title: "완료")
    
    override func configureHierarchy() {
        addSubview(profileImageView)
        addSubview(nicknameTextField)
        addSubview(lineView)
        addSubview(nicknameStateLabel)
        addSubview(doneButton)
    }
    
    override func configureLayout() {
        profileImageView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).inset(20)
            make.centerX.equalTo(safeAreaLayoutGuide)
            make.size.equalTo(100)
        }
        nicknameTextField.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        lineView.snp.makeConstraints { make in
            make.top.equalTo(nicknameTextField.snp.bottom).offset(12)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(1)
        }
        nicknameStateLabel.snp.makeConstraints { make in
            make.top.equalTo(lineView.snp.bottom).offset(12)
            make.height.equalTo(15)
            make.leading.equalTo(nicknameTextField)
        }
        doneButton.snp.makeConstraints { make in
            make.top.equalTo(nicknameStateLabel.snp.bottom).offset(40)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
    }
    
    override func configureView() {
        profileImageView.setState(isMain: true)
        profileImageView.isUserInteractionEnabled = true
        
        nicknameTextField.textColor = .mainLabel
        nicknameTextField.tintColor = .tint
        nicknameTextField.placeholder = Resource.Placeholder.nickname.rawValue
        
        lineView.backgroundColor = .mainLabel
        
        nicknameStateLabel.font = .systemFont(ofSize: 13)
        nicknameStateLabel.textColor = .tint
        
        doneButton.isEnabled = false
    }
}

extension EditProfileNicknameView {
    func setProfileImageView(profileImageIndex: Int, gesture: UIGestureRecognizer? = nil) {
        profileImageView.setProfileImage(image: Resource.AssetImage.profile(profileImageIndex).path)
        if let gesture {
            profileImageView.addGestureRecognizer(gesture)
        }
    }
    
    func setNicknameTextField(text: String) {
        nicknameTextField.text = text
    }
    
    func setButtonHidden(isHidden: Bool) {
        doneButton.isHidden = isHidden
    }
    
    func setButtonEnable(isEnabled: Bool) {
        doneButton.isEnabled = isEnabled
    }
    
    func updateNicknameState(nicknameState: Resource.NicknameState) {
        nicknameStateLabel.text = nicknameState.rawValue
        doneButton.isEnabled = nicknameState == .correct ? true : false
    }
}
