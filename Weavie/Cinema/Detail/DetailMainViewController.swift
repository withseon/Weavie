//
//  DetailMainViewController.swift
//  Weavie
//
//  Created by 정인선 on 1/29/25.
//

import UIKit

final class DetailMainViewController: BaseViewController {
    private let mainView = DetailMainView()
    private var movie: Movie
    private var isLiked: Bool
    private var onUpdate: (() -> Void)?
    private var backdropImages = [ImageInfo]()
    private var posterImages = [ImageInfo]()
    private var casts = [Cast]()
    
    init(movie: Movie, isLiked: Bool, onUpdate: (() -> Void)?) {
        self.movie = movie
        self.isLiked = isLiked
        self.onUpdate = onUpdate
        super.init()
    }
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        configurePageControl()
        configureButton()
        fetchMovieInfo()
    }
    
    override func configureNavigation() {
        navigationItem.title = movie.title
        let likeButton = UIBarButtonItem(image: UIImage(systemName: isLiked ? "heart.fill" : "heart"), style: .plain, target: self, action: #selector(likeButtonTapped))
        navigationItem.rightBarButtonItem = likeButton
    }
    
    @objc
    private func likeButtonTapped() {
        var likedMovies = UserDefaultsManager.likedMovies ?? []
        isLiked.toggle()
        navigationItem.rightBarButtonItem?.image = UIImage(systemName: isLiked ? "heart.fill" : "heart")
        if isLiked {
            likedMovies.insert(movie.id)
        } else {
            likedMovies.remove(movie.id)
        }
        UserDefaultsManager.likedMovies = likedMovies
        onUpdate?()
    }
}

// MARK: - Network
extension DetailMainViewController {
    private func fetchMovieInfo() {
        let group = DispatchGroup()
        fetchMovieImageData(group: group)
        fetchCreditData(group: group)
        group.notify(queue: .main) { [weak self] in
            guard let self else { return }
            mainView.configureContent(movie: movie)
            mainView.pageControl.numberOfPages = backdropImages.count
        }
    }
    
    private func fetchMovieImageData(group: DispatchGroup) {
        group.enter()
        TMDBManager.executeFetch(api: .image(id: movie.id), type: MovieImage.self) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let success):
                backdropImages = Array(success.backdrops.prefix(5))
                posterImages = success.posters
                group.leave()
            case .failure(let failure):
                showAlert(withCancel: false, title: "네트워크 오류", message: failure.message, actionTitle: "확인")
                group.leave()
            }
        }
    }
    
    private func fetchCreditData(group: DispatchGroup) {
        group.enter()
        TMDBManager.executeFetch(api: .credit(id: movie.id), type: Credit.self) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let success):
                casts = success.cast
                group.leave()
            case .failure(let failure):
                showAlert(withCancel: false, title: "네트워크 오류", message: failure.message, actionTitle: "확인")
                group.leave()
            }
        }
    }
}

// MARK: - Configure PageControl, CollectionView, Button
extension DetailMainViewController {
    private func configurePageControl() {
        mainView.pageControl.currentPage = 0
    }
    
    private func configureCollectionView() {
        mainView.backdropCollectionView.isPagingEnabled = true
        mainView.backdropCollectionView.showsHorizontalScrollIndicator = false
        mainView.backdropCollectionView.delegate = self
        mainView.backdropCollectionView.dataSource = self
        mainView.backdropCollectionView.register(BackdropCollectionViewCell.self, forCellWithReuseIdentifier: BackdropCollectionViewCell.identifier)
        
        mainView.castCollectionView.showsHorizontalScrollIndicator = false
        mainView.castCollectionView.delegate = self
        mainView.castCollectionView.dataSource = self
        mainView.castCollectionView.register(CastCollectionViewCell.self, forCellWithReuseIdentifier: CastCollectionViewCell.identifier)
        
        mainView.posterCollectionView.showsHorizontalScrollIndicator = false
        mainView.posterCollectionView.delegate = self
        mainView.posterCollectionView.dataSource = self
        mainView.posterCollectionView.register(PosterCollectionViewCell.self, forCellWithReuseIdentifier: PosterCollectionViewCell.identifier)
    }
    
    private func configureButton() {
        mainView.moreButton.addTarget(self, action: #selector(moreButtonTapped), for: .touchUpInside)
    }
    
    @objc
    private func moreButtonTapped() {
        mainView.moreButton.isSelected.toggle()
        mainView.changeSynopsisLabelLine(isButtonSelected: mainView.moreButton.isSelected)
    }
}

extension DetailMainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == mainView.backdropCollectionView {
            return backdropImages.count
        } else if collectionView == mainView.castCollectionView {
            return casts.count
        } else {
            return posterImages.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == mainView.backdropCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BackdropCollectionViewCell.identifier, for: indexPath) as? BackdropCollectionViewCell else { return UICollectionViewCell() }
            cell.configureContent(filePath: backdropImages[indexPath.item].filePath)
            return cell
        } else if collectionView == mainView.castCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CastCollectionViewCell.identifier, for: indexPath) as? CastCollectionViewCell else { return UICollectionViewCell() }
            cell.configureContent(cast: casts[indexPath.item])
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PosterCollectionViewCell.identifier, for: indexPath) as? PosterCollectionViewCell else { return UICollectionViewCell() }
            cell.configureContent(filePath: posterImages[indexPath.item].filePath)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if collectionView == mainView.backdropCollectionView {
            mainView.pageControl.currentPage = indexPath.item
        }
    }
}
