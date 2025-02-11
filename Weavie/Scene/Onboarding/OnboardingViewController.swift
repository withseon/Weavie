//
//  OnboardingViewController.swift
//  Weavie
//
//  Created by 정인선 on 1/31/25.
//

import UIKit

final class OnboardingViewController: BaseViewController {
    private let mainView = OnboardingView()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureButton()
    }
    
    override func configureNavigation() {
        super.configureNavigation()
        navigationController?.isNavigationBarHidden = true
    }
}

extension OnboardingViewController {
    private func configureButton() {
        mainView.startButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
    }
    
    @objc
    private func startButtonTapped() {
        let vc = EditProfileNicknameViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}
