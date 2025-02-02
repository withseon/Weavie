//
//  EditProfileNicknameViewController.swift
//  Weavie
//
//  Created by 정인선 on 1/30/25.
//

import UIKit
import SnapKit

final class EditProfileNicknameViewController: BaseViewController {
    private let mainView = EditProfileNicknameView()
    private var profileImageIndex = (0..<Resource.AssetImage.profileCount).randomElement() ?? 0
    private var nickname: String = ""
    private let notificationCenter = NotificationCenter.default
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTextField()
        configureButton()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    override func configureNavigation() {
        super.configureNavigation()
        guard let rootView = navigationController?.viewControllers.first else { return }
        if rootView is OnboardingViewController {
            navigationItem.title = Resource.NavTitle.makeNickname.rawValue
            navigationController?.isNavigationBarHidden = false
        } else {
            navigationItem.title = Resource.NavTitle.editNickname.rawValue
            let saveButton = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(saveButtonTapped))
            let backButton = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(backButtonTapped))
            navigationItem.rightBarButtonItem = saveButton
            navigationItem.leftBarButtonItem = backButton
        }
    }
    
    @objc
    private func saveButtonTapped(sender: UIButton) {
        guard let text = mainView.nicknameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        nickname = text
        if let oldUser = UserDefaultsManager.user {
            UserDefaultsManager.user = User(nickname: nickname,
                                            imageIndex: profileImageIndex,
                                            registerDate: oldUser.registerDate)
        } else {
            UserDefaultsManager.user = User(nickname: nickname,
                                            imageIndex: profileImageIndex,
                                            registerDate: Date.now)
            UserDefaultsManager.likedMovies = []
            UserDefaultsManager.searchRecord = [:]
        }
        if sender == mainView.doneButton {
            changeRootViewController(vc: MainTabBarController())
        } else {
            dismiss(animated: true) { [weak self] in
                guard let self else { return }
                notificationCenter.post(name: .user,
                                        object: nil)
            }
        }
    }
    
    @objc
    private func backButtonTapped() {
        dismiss(animated: true)
    }
    
    override func configureView() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(profileImageViewTapped))
        mainView.setProfileImageView(profileImageIndex: profileImageIndex, gesture: gesture)
        mainView.setNicknameTextField(text: nickname)
        
        let isRootView = navigationController?.viewControllers.first == self
        mainView.setButtonHidden(isHidden: isRootView)
    }
    
    @objc
    private func profileImageViewTapped() {
        let vc = EditProfileImageViewController(profileImageIndex: profileImageIndex) { [weak self] profileImageIndex in
            guard let self else { return }
            self.profileImageIndex = profileImageIndex
            mainView.setProfileImageView(profileImageIndex: profileImageIndex)
        }
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension EditProfileNicknameViewController {
    private func configureTextField() {
        mainView.nicknameTextField.addTarget(self, action: #selector(editingTextField), for: .editingChanged)
    }
    
    @objc
    private func editingTextField() {
        var nicknameState: Resource.NicknameState = .correct
        let specialCharSet = CharacterSet(charactersIn: "@#$%")
        guard let currentText = mainView.nicknameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        
        if currentText.count < 2 || currentText.count > 9 {
            nicknameState = .lengthViolation
        } else if currentText.rangeOfCharacter(from: .whitespacesAndNewlines) != nil {
            nicknameState = .whitespaceViolation
        } else if currentText.rangeOfCharacter(from: .decimalDigits) != nil {
            nicknameState = .numberViolation
        } else if currentText.rangeOfCharacter(from: specialCharSet) != nil {
            nicknameState = .specialCharacterViolation
        }
        
        mainView.updateNicknameState(nicknameState: nicknameState)
        navigationItem.rightBarButtonItem?.isEnabled = nicknameState == .correct ? true : false
    }
    
    private func configureButton() {
        mainView.doneButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
    }
}

extension EditProfileNicknameViewController {
    func updateUserInfo(user: User) {
        nickname = user.nickname
        profileImageIndex = user.imageIndex
    }
}
