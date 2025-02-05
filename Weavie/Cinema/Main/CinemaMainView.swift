//
//  CinemaMainView.swift
//  Weavie
//
//  Created by 정인선 on 1/25/25.
//

import UIKit
import SnapKit

final class CinemaMainView: BaseView {
    private let profileCardView = ProfileCardView()
    private let searchTitleLabel = TitleLabel(text: "최근 검색어")
    private let searchTitleLabel = TitleLabel(text: Resource.LabelText.searchRecord.rawValue)
    let deleteAllButton = UIButton()
    private let resultCoverView = UIView()
    let recentSearchCollectionView = UICollectionView(frame: .zero, collectionViewLayout: getRecentSearchCollectionViewLayout())
    private let emptyLabel = UILabel()
    private let movieTitleLabel = TitleLabel(text: "오늘의 영화")
    private let movieTitleLabel = TitleLabel(text: Resource.LabelText.todayMovie.rawValue)
    let movieCollectionView = UICollectionView(frame: .zero, collectionViewLayout: getMovieCollectionViewLayout())
    
    override func configureHierarchy() {
        addSubview(profileCardView)
        addSubview(searchTitleLabel)
        addSubview(deleteAllButton)
        addSubview(resultCoverView)
        resultCoverView.addSubview(recentSearchCollectionView)
        resultCoverView.addSubview(emptyLabel)
        addSubview(movieTitleLabel)
        addSubview(movieCollectionView)
    }
    
    override func configureLayout() {
        profileCardView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
        }
        searchTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(profileCardView.snp.bottom).offset(20)
            make.leading.equalToSuperview().inset(20)
        }
        deleteAllButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.centerY.equalTo(searchTitleLabel)
        }
        resultCoverView.snp.makeConstraints { make in
            make.top.equalTo(searchTitleLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(30)
        }
        emptyLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        recentSearchCollectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        movieTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(resultCoverView.snp.bottom).offset(20)
            make.leading.equalToSuperview().inset(20)
        }
        movieCollectionView.snp.makeConstraints { make in
            make.top.equalTo(movieTitleLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(safeAreaLayoutGuide).inset(12)
        }
    }
    
    override func configureView() {
        profileCardView.isUserInteractionEnabled = true
        
        var deleteConfig = UIButton.Configuration.plain()
        deleteConfig.attributedTitle = AttributedString("전체 삭제",
                                                        attributes: AttributeContainer([.font: UIFont.systemFont(ofSize: 14, weight: .bold),
                                                                                         .foregroundColor: UIColor.tint]))
        deleteConfig.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        deleteAllButton.configuration = deleteConfig
        
        emptyLabel.text = "최근 검색어 내역이 없습니다."
        emptyLabel.font = .systemFont(ofSize: 14)
        emptyLabel.textColor = .subLabel
    }
}

// MARK: - UI 업데이트
extension CinemaMainView {
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

    func updateSearchRecordView(isEmpty: Bool) {
        if isEmpty {
            emptyLabel.isHidden = false
            deleteAllButton.isHidden = true
        } else {
            emptyLabel.isHidden = true
            deleteAllButton.isHidden = false
        }
    }
}

// MARK: - CollectionView 레이아웃
extension CinemaMainView {
    static func getRecentSearchCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(50),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(50),
                                               heightDimension: .fractionalHeight(1.0))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = 10
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    static func getMovieCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(200),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(200),
                                               heightDimension: .fractionalHeight(1.0))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = 20
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }

}
