//
//  EditProfileImageViewController.swift
//  Weavie
//
//  Created by 정인선 on 1/31/25.
//

import UIKit

final class EditProfileImageViewController: BaseViewController {
    private let mainView = EditProfileImageView()
    private let viewModel: EditProfileImageViewModel
    private let updateProfileImage: ((Int) -> Void)?
    
    init(imageIndex: Int, onUpdate: ((Int) -> Void)? = nil) {
        viewModel = EditProfileImageViewModel(oldImageIndex: imageIndex)
        viewModel.inputImageIndex.value = imageIndex
        self.updateProfileImage = onUpdate
        super.init()
    }
    
    deinit {
        print("❗️EditProfile VC Deinit")
    }
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        bindData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.inputImageChange.value = ()
    }
    
    override func configureNavigation() {
        super.configureNavigation()
        guard let rootView = navigationController?.viewControllers.first else { return }
        if rootView is OnboardingViewController {
            navigationItem.title = Resource.NavTitle.makeProfileImage.rawValue
        } else {
            navigationItem.title = Resource.NavTitle.editProfileImage.rawValue
        }
    }
}

// MARK: - VM bind
extension EditProfileImageViewController {
    private func bindData() {
        viewModel.outputImageIndex.bind { [weak self] imageIndex in
            print("profileImage:: outputImageIndex bind ===")
            guard let self, let imageIndex else { return }
            mainView.setProfileImageView(profileImageIndex: imageIndex)
            mainView.profileImageCollectionView.selectItem(at: IndexPath(item: imageIndex, section: 0),
                                                           animated: true,
                                                           scrollPosition: .centeredVertically)
        }
        viewModel.outputImageChange.lazyBind { [weak self] selectedImageIndex in
            print("profileImage:: outputImageChange bind ===")
            guard let self, let selectedImageIndex else { return }
            updateProfileImage?(selectedImageIndex)
        }
    }
}

// MARK: - 컬렉션뷰 설정
extension EditProfileImageViewController {
    private func configureCollectionView() {
        mainView.profileImageCollectionView.delegate = self
        mainView.profileImageCollectionView.dataSource = self
        mainView.profileImageCollectionView.register(ProfileImageControllerCell.self, forCellWithReuseIdentifier: ProfileImageControllerCell.identifier)
    }
}

// MARK: - 컬렉션 뷰 델리게이트, 데이터소스
extension EditProfileImageViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Resource.AssetImage.profileCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileImageControllerCell.identifier, for: indexPath) as? ProfileImageControllerCell else { return UICollectionViewCell() }
        cell.configureContent(imageIndex: indexPath.item)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.inputImageIndex.value = indexPath.item
    }
}
