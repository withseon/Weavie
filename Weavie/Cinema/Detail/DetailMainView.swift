//
//  DetailMainView.swift
//  Weavie
//
//  Created by 정인선 on 1/29/25.
//

import UIKit
import SnapKit

final class DetailMainView: BaseView {
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    let backdropCollectionView = UICollectionView(frame: .zero, collectionViewLayout: getBackdropCollectionViewLayout())
    let pageControl = UIPageControl()
    private let stackView = UIStackView()
    private let calendarImageView = UIImageView()
    private let releaseLabel = UILabel()
    private let starImageView = UIImageView()
    private let gradeLabel = UILabel()
    private let filmImageView = UIImageView()
    private let filmLabel = UILabel()
    private let firstSeparatorView = UIView()
    private let secondSeparatorView = UIView()
    private let synopsisTitleLabel = TitleLabel(text: Resource.LabelText.synopsis.rawValue)
    private let synopsisLabel = UILabel()
    let moreButton = UIButton()
    private let castTitleLabel = TitleLabel(text: Resource.LabelText.cast.rawValue)
    let castCollectionView = UICollectionView(frame: .zero, collectionViewLayout: getCastCollectionViewLayout())
    private let posterTitleLabel = TitleLabel(text: Resource.LabelText.poster.rawValue)
    let posterCollectionView = UICollectionView(frame: .zero, collectionViewLayout: getPosterCollectionViewLayout())
        
    override func configureHierarchy() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(backdropCollectionView)
        contentView.addSubview(pageControl)
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(calendarImageView)
        stackView.addArrangedSubview(releaseLabel)
        stackView.addArrangedSubview(firstSeparatorView)
        stackView.addArrangedSubview(starImageView)
        stackView.addArrangedSubview(gradeLabel)
        stackView.addArrangedSubview(secondSeparatorView)
        stackView.addArrangedSubview(filmImageView)
        stackView.addArrangedSubview(filmLabel)
        contentView.addSubview(synopsisTitleLabel)
        contentView.addSubview(synopsisLabel)
        contentView.addSubview(moreButton)
        contentView.addSubview(castTitleLabel)
        contentView.addSubview(castCollectionView)
        contentView.addSubview(posterTitleLabel)
        contentView.addSubview(posterCollectionView)
    }
    
    override func configureLayout() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }
        contentView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.verticalEdges.equalToSuperview()
        }
        backdropCollectionView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalTo(backdropCollectionView.snp.width).multipliedBy(0.66)
        }
        pageControl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(backdropCollectionView).offset(-8)
        }
        stackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(backdropCollectionView.snp.bottom).offset(8)
        }
        calendarImageView.snp.makeConstraints { make in
            make.size.equalTo(12)
        }
        starImageView.snp.makeConstraints { make in
            make.size.equalTo(12)
        }
        filmImageView.snp.makeConstraints { make in
            make.size.equalTo(12)
        }
        firstSeparatorView.snp.makeConstraints { make in
            make.height.equalToSuperview()
            make.width.equalTo(1)
        }
        secondSeparatorView.snp.makeConstraints { make in
            make.height.equalToSuperview()
            make.width.equalTo(1)
        }
        synopsisTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom).offset(20)
            make.leading.equalToSuperview().inset(20)
        }
        synopsisLabel.snp.makeConstraints { make in
            make.top.equalTo(synopsisTitleLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        moreButton.snp.makeConstraints { make in
            make.leading.greaterThanOrEqualTo(synopsisTitleLabel.snp.trailing).offset(12)
            make.trailing.equalToSuperview().inset(20)
            make.centerY.equalTo(synopsisTitleLabel)
        }
        castTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(synopsisLabel.snp.bottom).offset(20)
            make.leading.equalToSuperview().inset(20)
        }
        castCollectionView.snp.makeConstraints { make in
            make.top.equalTo(castTitleLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(120)
        }
        posterTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(castCollectionView.snp.bottom).offset(20)
            make.leading.equalToSuperview().inset(20)
        }
        posterCollectionView.snp.makeConstraints { make in
            make.top.equalTo(posterTitleLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(200)
            make.bottom.equalToSuperview().inset(20)
        }
    }
    
    override func configureView() {
        scrollView.showsVerticalScrollIndicator = false
        stackView.axis = .horizontal
        stackView.spacing = 8
        
        calendarImageView.image = UIImage(systemName: "calendar")
        calendarImageView.tintColor = .subLabel
        releaseLabel.text = "yyy-MM-dd"
        releaseLabel.textColor = .subLabel
        releaseLabel.font = .systemFont(ofSize: 12)
        starImageView.image = UIImage(systemName: "star.fill")
        starImageView.tintColor = .subLabel
        gradeLabel.text = "0.0"
        gradeLabel.textColor = .subLabel
        gradeLabel.font = .systemFont(ofSize: 12)
        filmImageView.image = UIImage(systemName: "calendar")
        filmImageView.tintColor = .subLabel
        filmLabel.text = "-"
        filmLabel.textColor = .subLabel
        filmLabel.font = .systemFont(ofSize: 12)
        firstSeparatorView.backgroundColor = .subLabel
        secondSeparatorView.backgroundColor = .subLabel
        
        synopsisLabel.numberOfLines = 0
        synopsisLabel.font = .systemFont(ofSize: 13)
        
        moreButton.setAttributedTitle(NSAttributedString(string: "More", attributes: [.font: UIFont.systemFont(ofSize: 13, weight: .semibold)]), for: .normal)
        moreButton.setAttributedTitle(NSAttributedString(string: "Hide", attributes: [.font: UIFont.systemFont(ofSize: 13, weight: .semibold)]), for: .selected)
        moreButton.setTitleColor(.tint, for: .normal)
        moreButton.setTitleColor(.tint, for: .selected)
    }
}

extension DetailMainView {
    static func getBackdropCollectionViewLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        let width = UIScreen.main.bounds.width
        layout.itemSize = CGSize(width: width, height: width * 0.66)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        return layout
    }
    
    static func getCastCollectionViewLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 20
        let width = UIScreen.main.bounds.width - (20 * 3)
        layout.itemSize = CGSize(width: width / 2, height: 50)
        layout.sectionInset = UIEdgeInsets(top: 0, left: spacing, bottom: 0, right: spacing)
        layout.scrollDirection = .horizontal
        return layout
    }
    
    static func getPosterCollectionViewLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 20
        let height: CGFloat = 200
        layout.itemSize = CGSize(width: height * 0.66, height: height)
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: spacing, bottom: 0, right: spacing)
        return layout
    }
}

extension DetailMainView {
    func configureContent(movie: Movie) {
        releaseLabel.text = movie.releaseDate
        gradeLabel.text = String(format: "%.1f", movie.voteAverage)
        if !movie.genreIDs.isEmpty {
            filmLabel.text = movie.genreIDs
                                    .prefix(2)
                                    .map { Resource.Genre(rawValue: $0)?.name ?? "-" }.joined(separator: ", ")
        }
        synopsisLabel.text = movie.overview
        
        let oldLabelHeight = synopsisLabel.intrinsicContentSize.height
        synopsisLabel.numberOfLines = 3
        let newLabelHeight = synopsisLabel.intrinsicContentSize.height
        moreButton.isHidden = oldLabelHeight <= newLabelHeight
    }
    
    func changeSynopsisLabelLine(isButtonSelected: Bool) {
        synopsisLabel.numberOfLines = isButtonSelected ? 0 : 3
    }
}
