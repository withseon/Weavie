//
//  EditProfileImageViewController.swift
//  Weavie
//
//  Created by 정인선 on 1/31/25.
//

import UIKit

final class EditProfileImageViewController: BaseViewController {
    private let mainView = EditProfileImageView()
    private var profileImageIndex: Int
    var onUpdate: ((Int) -> Void)?
    
    init(profileImageIndex: Int, onUpdate: ((Int) -> Void)? = nil) {
        self.profileImageIndex = profileImageIndex
        self.onUpdate = onUpdate
        super.init()
    }
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        onUpdate?(profileImageIndex)
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
    
    override func configureView() {
        mainView.setProfileImageView(profileImageIndex: profileImageIndex)
    }
}

extension EditProfileImageViewController {
    private func configureCollectionView() {
        mainView.profileImageCollectionView.delegate = self
        mainView.profileImageCollectionView.dataSource = self
        mainView.profileImageCollectionView.register(ProfileImageControllerCell.self, forCellWithReuseIdentifier: ProfileImageControllerCell.identifier)
        mainView.profileImageCollectionView.selectItem(at: IndexPath(item: profileImageIndex, section: 0), animated: true, scrollPosition: .centeredVertically)
    }
}

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
        let selectedProfileImageIndex = indexPath.item
        if profileImageIndex != selectedProfileImageIndex {
            mainView.setProfileImageView(profileImageIndex: selectedProfileImageIndex)
            profileImageIndex = selectedProfileImageIndex
        }
    }
}
