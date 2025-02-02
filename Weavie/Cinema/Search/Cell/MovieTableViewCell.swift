//
//  MovieTableViewCell.swift
//  Weavie
//
//  Created by 정인선 on 1/28/25.
//

import UIKit
import SnapKit

final class MovieTableViewCell: UITableViewCell {
    private let posterImageView = UIImageView()
    private let movieTitleLabel = UILabel()
    private let releaseDateLabel = UILabel()
    private let genreStackView = UIStackView()
    let likeButton = UIButton()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        posterImageView.image = nil
        movieTitleLabel.text = "Title"
        releaseDateLabel.text = "yyyy. MM. dd"
        genreStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
    }
}

extension MovieTableViewCell {
    private func configureUI() {
        configureHierarchy()
        configureLayout()
        configureView()
    }
    
    private func configureHierarchy() {
        contentView.addSubview(posterImageView)
        contentView.addSubview(movieTitleLabel)
        contentView.addSubview(releaseDateLabel)
        contentView.addSubview(genreStackView)
        contentView.addSubview(likeButton)
    }
    
    private func  configureLayout() {
        posterImageView.snp.makeConstraints { make in
            make.width.equalTo(posterImageView.snp.height).multipliedBy(0.66)
            make.leading.equalToSuperview().inset(20)
            make.verticalEdges.equalToSuperview().inset(12)
        }
        movieTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(12)
            make.trailing.equalToSuperview().inset(20)
            make.leading.equalTo(posterImageView.snp.trailing).offset(8)
        }
        releaseDateLabel.snp.makeConstraints { make in
            make.top.equalTo(movieTitleLabel.snp.bottom).offset(4)
            make.leading.equalTo(movieTitleLabel)
        }
        genreStackView.snp.makeConstraints { make in
            make.leading.equalTo(movieTitleLabel)
            make.bottom.equalToSuperview().inset(12)
        }
        likeButton.snp.makeConstraints { make in
            make.leading.greaterThanOrEqualTo(genreStackView.snp.trailing).offset(8)
            make.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(12)
        }
    }
    
    private func configureView() {
        posterImageView.backgroundColor = .systemGray
        posterImageView.clipsToBounds = true
        posterImageView.layer.cornerRadius = 10
        
        movieTitleLabel.text = "TITLETITLETITLETITLETITLETITLETITLETITLETITLETITLETITLETITLETITLETITLETITLETITLETITLETITLETITLETITLE"
        movieTitleLabel.textColor = .mainLabel
        movieTitleLabel.font = .systemFont(ofSize: 14, weight: .bold)
        movieTitleLabel.numberOfLines = 2
        
        releaseDateLabel.text = "8888. 88. 88"
        releaseDateLabel.textColor = .subLabel
        releaseDateLabel.font = .systemFont(ofSize: 13)
        
        genreStackView.axis = .horizontal
        genreStackView.spacing = 4
        genreStackView.distribution = .equalSpacing
        
        likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
        likeButton.tintColor = .tint
    }
}

// MARK: - UI 업데이트
extension MovieTableViewCell {
    func configureContent(movie: Movie) {
        if let posterPath = movie.posterPath {
            posterImageView.setKFImage(strURL: "https://image.tmdb.org/t/p/w500\(posterPath)")
        if movie.posterPath != "unknown" {
            let url = TMDBManager.getImageURL(type: .subPoster, filePath: movie.posterPath)
            posterImageView.setKFImage(strURL: url)
        }
        movieTitleLabel.text = movie.title
        let releaseDate = movie.releaseDate.toDate("yyyy-MM-dd")
        releaseDateLabel.text = releaseDate?.toFormattedString("yyyy. MM. dd")
        
        let genreIDs = Array(movie.genreIDs.prefix(2))
        createGenreTags(genreIDs: genreIDs)
    }
    
    private func createGenreTags(genreIDs: [Int]) {
        genreIDs.forEach { genreID in
            if let genre = Genre(rawValue: genreID) {
                genreStackView.addArrangedSubview(GenreLabel(text: genre.name))
            }
        }
    }
}
