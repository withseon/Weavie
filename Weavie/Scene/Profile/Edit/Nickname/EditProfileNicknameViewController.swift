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
    private let viewModel = EditProfileNicknameViewModel()
    
    override func loadView() {
        view = mainView
    }
    
    deinit {
        print("❗️EditNickname VC Deinit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTextField()
        configureCollectionView()
        configureButton()
        bindData()
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
        viewModel.inputUserDefaultsSave.value = ()
    }
    
    @objc
    private func backButtonTapped() {
        dismiss(animated: true)
    }
    
    override func configureView() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(profileImageViewTapped))
        mainView.setProfileImageGesture(gesture: gesture)
        
        let isRootView = navigationController?.viewControllers.first == self
        mainView.setButtonHidden(isHidden: isRootView)
    }
    
    @objc
    private func profileImageViewTapped() {
        let vc = EditProfileImageViewController(imageIndex: viewModel.outputImageIndex.value) { [weak self] imageIndex in
            guard let self else { return }
            viewModel.inputImageIndex.value = imageIndex
        }
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension EditProfileNicknameViewController {
    private func bindData() {
        viewModel.outputUser.bind { [weak self] userInfo in
            print("Nickname:: outputUser bind ===")
            guard let self, let userInfo else { return }
            mainView.setNicknameTextField(text: userInfo.nickname)
            userInfo.mbtiIndicies.forEach { [weak self] index in
                guard let self else { return }
                mainView.mbtiCollectionView.selectItem(at: IndexPath(item: index, section: 0),
                                                       animated: false,
                                                       scrollPosition: .centeredHorizontally)
            }
        }
        viewModel.outputNicknameState.lazyBind { [weak self] nicknameState in
            print("Nickname:: outputNicknameState bind ===")
            guard let self else { return }
            mainView.updateNicknameState(stateText: nicknameState)
        }
        viewModel.outputDeselectedIndex.lazyBind { [weak self] index in
            print("Nickname:: outputDeselectedIndex bind ===")
            guard let self, let index else { return }
            mainView.mbtiCollectionView.deselectItem(at: IndexPath(item: index, section: 0), animated: false)
        }
        viewModel.outputButtonEnable.bind { [weak self] isEnabled in
            print("Nickname:: outputButtonEnable bind ===")
            guard let self else { return }
            mainView.updateDoneButtonState(isEnabled: isEnabled)
            navigationItem.rightBarButtonItem?.isEnabled = isEnabled
        }
        viewModel.outputImageIndex.bind { [weak self] imageIndex in
            print("Nickname:: outputImageIndex bind ===")
            guard let self else { return }
            mainView.setProfileImageView(profileImageIndex: imageIndex)
        }
        viewModel.outputUserDefaultsDone.lazyBind { [weak self] _ in
            print("Nickname:: outputUserDefaultsDone bind ===")
            guard let self,
                  let rootView = navigationController?.viewControllers.first else { return }
            if rootView is OnboardingViewController {
                changeRootViewController(vc: MainTabBarController())
            } else {
                viewModel.inputNotificationPost.value = ()
            }
        }
        viewModel.outputNotificationPost.lazyBind { [weak self] _ in
            guard let self else { return }
            dismiss(animated: true)
        }
    }
}

extension EditProfileNicknameViewController {
    private func configureTextField() {
        mainView.nicknameTextField.delegate = self
    }
    
    private func configureCollectionView() {
        mainView.mbtiCollectionView.allowsMultipleSelection = true
        mainView.mbtiCollectionView.delegate = self
        mainView.mbtiCollectionView.dataSource = self
        mainView.mbtiCollectionView.register(MBTICollectionViewCell.self,
                                             forCellWithReuseIdentifier: MBTICollectionViewCell.identifier)
    }
    
    private func configureButton() {
        mainView.doneButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
    }
}

extension EditProfileNicknameViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        viewModel.inputNickname.value = textField.text
    }
}

extension EditProfileNicknameViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.mbtiTitles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MBTICollectionViewCell.identifier, for: indexPath) as? MBTICollectionViewCell else { return UICollectionViewCell() }
        cell.configureContent(text: viewModel.mbtiTitles[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.inputSelectedIndex.value = indexPath.item
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        viewModel.inputDeselectedIndex.value = indexPath.item
    }
}

extension EditProfileNicknameViewController {
    func updateUserInfo(user: User) {
        viewModel.inputUser.value = user
    }
}
