//
//  MovieCollectionViewCell.swift
//  Weavie
//
//  Created by 정인선 on 1/25/25.
//

import UIKit
import SnapKit

class MovieCollectionViewCell: BaseCollectionViewCell {
final class MovieCollectionViewCell: BaseCollectionViewCell {
    private let posterImageView = UIImageView()
    private let titleLabel = UILabel()
    let likeButton = UIButton()
    private let descriptionLabel = UILabel()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        posterImageView.image = nil
        titleLabel.text = "Title"
        descriptionLabel.text = "Description"
    }
    
    override func configureHierarchy() {
        contentView.addSubview(posterImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(likeButton)
        contentView.addSubview(descriptionLabel)
    }
    
    override func configureLayout() {
        posterImageView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.width.equalTo(posterImageView.snp.height).multipliedBy(0.66)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(posterImageView.snp.bottom).offset(4)
            make.height.equalTo(20)
            make.leading.equalToSuperview()
        }
        likeButton.snp.makeConstraints { make in
            make.top.equalTo(posterImageView.snp.bottom).offset(4)
            make.size.equalTo(titleLabel.snp.height)
            make.leading.greaterThanOrEqualTo(titleLabel.snp.trailing).offset(8)
            make.trailing.equalToSuperview()
        }
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.height.equalTo(40)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    override func configureView() {
        posterImageView.backgroundColor = .subLabel
        posterImageView.layer.cornerRadius = 10
        posterImageView.contentMode = .scaleAspectFill
        posterImageView.clipsToBounds = true
        
        titleLabel.text = "Title"
        titleLabel.textColor = .mainLabel
        titleLabel.font = .systemFont(ofSize: 15, weight: .semibold)
        
        likeButton.configurationUpdateHandler = { button in
            var config = UIButton.Configuration.plain()
            config.baseBackgroundColor = .clear
            config.baseForegroundColor = .tint
            switch button.state {
            case .selected:
                config.image = UIImage(systemName: "heart.fill")
            default:
                config.image = UIImage(systemName: "heart")
            }
            button.configuration = config
        }
        
        descriptionLabel.text = "DescriptionDescriptionDescriptionDescriptionDescriptionDescriptionDescriptionDescriptionDescriptionDescriptionDescriptionDescriptionDescription"
        descriptionLabel.textColor = .mainLabel
        descriptionLabel.font = .systemFont(ofSize: 13)
        descriptionLabel.numberOfLines = 2
        descriptionLabel.layer.borderColor = UIColor.red.cgColor
        descriptionLabel.layer.borderWidth = 1
    }
}

extension MovieCollectionViewCell {
    func configureContent(movie: Movie) {
        posterImageView.setKFImage(strURL: "https://image.tmdb.org/t/p/w500\(movie.posterPath)")
        if movie.posterPath != "unknown" {
            let url = TMDBManager.getImageURL(type: .mainPoster, filePath: movie.posterPath)
            posterImageView.setKFImage(strURL: url)
        }
        titleLabel.text = movie.title
        descriptionLabel.text = movie.overview
    }
}
