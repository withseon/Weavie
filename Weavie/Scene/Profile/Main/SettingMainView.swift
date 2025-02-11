//
//  SettingMainView.swift
//  Weavie
//
//  Created by 정인선 on 1/26/25.
//

import UIKit
import SnapKit

final class SettingMainView: BaseView {
    private let profileCardView = ProfileCardView()
    let settingTableView = UITableView()
    
    override func configureHierarchy() {
        addSubview(profileCardView)
        addSubview(settingTableView)
    }
    
    override func configureLayout() {
        profileCardView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
        }
        settingTableView.snp.makeConstraints { make in
            make.top.equalTo(profileCardView.snp.bottom).offset(20)
            make.bottom.horizontalEdges.equalTo(safeAreaLayoutGuide)
        }
    }
}

extension SettingMainView {
    func updateProfileCardView(user: User? = nil, likedMovieCount: Int? = nil) {
        if let user {
            profileCardView.setUserProfile(user: user)
        }
        if let likedMovieCount {
            profileCardView.setMovieboxButton(likedMovieCount: likedMovieCount)
        }
    }

    func setProfileCardGesture(_ gesture: UIGestureRecognizer) {
        profileCardView.addGestureRecognizer(gesture)
    }
}
