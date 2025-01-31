//
//  OnboardingView.swift
//  Weavie
//
//  Created by 정인선 on 1/31/25.
//

import UIKit
import SnapKit

final class OnboardingView: BaseView {
    private let mainImageView = UIImageView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    let startButton = RoundBorderButton(title: "시작하기")
    
    override func configureHierarchy() {
        addSubview(mainImageView)
        addSubview(titleLabel)
        addSubview(descriptionLabel)
        addSubview(startButton)
    }
    
    override func configureLayout() {
        mainImageView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).inset(20)
            make.horizontalEdges.equalToSuperview()
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(mainImageView.snp.bottom)
            make.centerX.equalToSuperview()
        }
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.centerX.equalToSuperview()
        }
        startButton.snp.makeConstraints { make in
            make.bottom.equalTo(safeAreaLayoutGuide).inset(20)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
    }
    
    override func configureView() {
        mainImageView.image = UIImage(named: "onboarding")
        
        titleLabel.text = "Weavie"
        titleLabel.font = .systemFont(ofSize: 30, weight: .heavy)
        titleLabel.textColor = .mainLabel
        
        descriptionLabel.numberOfLines = 2
        descriptionLabel.textAlignment = .center
        descriptionLabel.text = """
                                당신만의 영화 세상,
                                Weavie를 시작해보세요.
                                """
        descriptionLabel.font = .systemFont(ofSize: 14)
        descriptionLabel.textColor = .mainLabel
    }
}
