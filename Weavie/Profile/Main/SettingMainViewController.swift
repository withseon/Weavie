//
//  SettingMainViewController.swift
//  Weavie
//
//  Created by 정인선 on 1/25/25.
//

import UIKit

final class SettingMainViewController: BaseViewController {
    private let mainView = SettingMainView()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        NotificationManager.center.addObserver(self,
                                       selector: #selector(updateProfile),
                                       name: .user,
                                       object: nil)
        NotificationManager.center.addObserver(self,
                                       selector: #selector(updateLikedMovies),
                                       name: .movieLike,
                                       object: nil)
    }
    
    @objc
    private func updateProfile() {
        guard let user = UserDefaultsManager.user else { return }
        mainView.updateProfileCardView(user: user)
    }
    
    @objc
    private func updateLikedMovies() {
        guard let likedMovies = UserDefaultsManager.likedMovies else { return }
        mainView.updateProfileCardView(likedMovieCount: likedMovies.count)
    }

    
    override func configureNavigation() {
        super.configureNavigation()
        navigationItem.title = Resource.NavTitle.setting.rawValue
    }
    
    override func configureView() {
        guard let user = UserDefaultsManager.user,
              let likedMovies = UserDefaultsManager.likedMovies else { return }
        mainView.updateProfileCardView(user: user, likedMovieCount: likedMovies.count)
        let gesture = UITapGestureRecognizer(target: self, action: #selector(profileCardViewTapped))
        mainView.setProfileCardGesture(gesture)
    }
    
    @objc
    private func profileCardViewTapped() {
        guard let user = UserDefaultsManager.user else { return }
        let vc = EditProfileNicknameViewController()
        vc.updateUserInfo(user: user)
        let nav = UINavigationController(rootViewController: vc)
        present(nav, animated: true)
    }
}

extension SettingMainViewController {
    private func configureTableView() {
        mainView.settingTableView.delegate = self
        mainView.settingTableView.dataSource = self
        mainView.settingTableView.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        mainView.settingTableView.isScrollEnabled = false
    }
}

extension SettingMainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Resource.Setting.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = Resource.Setting.allCases[indexPath.row].rawValue
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if Resource.Setting.allCases[indexPath.row] == Resource.Setting.Withdraw {
            showAlert(withCancel: true, title: "탈퇴하기", message: "탈퇴를 하면 데이터가 모두 초기화됩니다. 탈퇴 하시겠습니까?", actionTitle: "확인") { [weak self] in
                guard let self else { return }
                UserDefaultsManager.user = nil
                UserDefaultsManager.searchRecord = nil
                UserDefaultsManager.likedMovies = nil
                let nav = UINavigationController(rootViewController: OnboardingViewController())
                changeRootViewController(vc: nav)
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
