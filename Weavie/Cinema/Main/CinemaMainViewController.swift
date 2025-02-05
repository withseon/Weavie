//
//  CinemaMainViewController.swift
//  Weavie
//
//  Created by 정인선 on 1/25/25.
//

import UIKit

class CinemaMainViewController: BaseViewController {
    private let mainView = CinemaMainView()
    // 더미데이터
    private let user = User(nickname: "고래밥", imageNumber: 1, registerDate: Date())
    private let likedMovie = [1, 2, 3, 4, 123, 23]
    private var searchTexts = ["현빈", "스파이더", "해리포터", "소방관", "크리스마스"] {
        didSet {
            mainView.updateSearchRecordView(isEmpty: searchTexts.isEmpty)
    private var likedMovies = Set<Int>() {
        willSet {
            UserDefaultsManager.likedMovies = newValue
        }
    }
    private var trendMovies = [Movie]()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureButton()
        configureCollectionView()
        fetchTrendMovieData()
        mainView.updateSearchRecordView(isEmpty: searchTexts.isEmpty)
        NotificationManager.center.addObserver(self,
                                               selector: #selector(updateLikedMovies),
                                               name: .movieLike,
                                               object: nil)
    }
    
    @objc
    private func updateLikedMovies(value: Notification) {
        likedMovies = UserDefaultsManager.likedMovies ?? []
        mainView.updateProfileCardView(likedMovieCount: likedMovies.count)
        if let movieID = value.userInfo?[NotificationManager.movieKey] as? Int {
            if !trendMovies.filter({ $0.id == movieID }).isEmpty {
                mainView.movieCollectionView.reloadData()
            }
        }
    }
    
    override func configureNavigation() {
        super.configureNavigation()
        navigationItem.title = "Weavie"
        navigationItem.title = Resource.NavTitle.main.rawValue
        let searchButtonItem = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"),
                                            style: .plain,
                                            target: self,
                                            action: #selector(searchButtonItemTapped))
        navigationItem.rightBarButtonItem = searchButtonItem
    }
    
    override func configureView() {
        guard let user = UserDefaultsManager.user,
              let likedMovies = UserDefaultsManager.likedMovies,
              let searchRecord = UserDefaultsManager.searchRecord else { return }
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(profileCardViewTapped))
        mainView.updateProfileCardView(user: user, likedMovieCount: likedMovie.count, gesture: gesture)
        
        self.likedMovies = likedMovies
        self.searchRecord = searchRecord
        mainView.updateProfileCardView(user: user, likedMovieCount: likedMovies.count)
    }
    
    @objc
    private func searchButtonItemTapped() {
        let vc = SearchMainViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc
    private func profileCardViewTapped() {
        let nav = UINavigationController(rootViewController: ProfileMainViewController())
        present(nav, animated: true)
    }
}

// MARK: - Network
extension CinemaMainViewController {
    private func fetchTrendMovieData() {
        TMDBManager.executeFetch(api: .trending, type: TrendMovie.self) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let value):
                trendMovies = value.results
                mainView.movieCollectionView.reloadData()
            case .failure(let error):
                print(error.message)
            }
        }

    }
}

// MARK: - CollectionView, Button
extension CinemaMainViewController {
    private func configureCollectionView() {
        mainView.recentSearchCollectionView.isScrollEnabled = false
        mainView.recentSearchCollectionView.delegate = self
        mainView.recentSearchCollectionView.dataSource = self
        mainView.recentSearchCollectionView.register(RecentSearchCollectionViewCell.self, forCellWithReuseIdentifier: RecentSearchCollectionViewCell.identifier)
        
        mainView.movieCollectionView.isScrollEnabled = false
        mainView.movieCollectionView.delegate = self
        mainView.movieCollectionView.dataSource = self
        mainView.movieCollectionView.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: MovieCollectionViewCell.identifier)
    }
    
    private func configureButton() {
        mainView.deleteAllButton.addTarget(self, action: #selector(deleteAllButtonTapped), for: .touchUpInside)
    }
    
    @objc
    private func deleteAllButtonTapped() {
        print(#function)
        searchTexts.removeAll()
        mainView.recentSearchCollectionView.reloadData()
    }
}

// MARK: - CollectionViewDelegate, CollectionViewDataSource
extension CinemaMainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == mainView.recentSearchCollectionView {
            return searchTexts.count
        } else {
            return trendMovies.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == mainView.recentSearchCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecentSearchCollectionViewCell.identifier, for: indexPath) as? RecentSearchCollectionViewCell else { return UICollectionViewCell() }
            cell.configureContent(text: searchTexts[indexPath.item])
            let gesture = UITapGestureRecognizer(target: self, action: #selector(xmarkImageTapped))
            cell.setupXmark(tag: indexPath.item, gesture: gesture)
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionViewCell.identifier, for: indexPath) as? MovieCollectionViewCell else { return UICollectionViewCell() }
            let movie = trendMovies[indexPath.item]
            cell.configureContent(movie: movie)
            cell.likeButton.isSelected = likedMovies.contains(movie.id)
            cell.likeButton.tag = indexPath.item
            cell.likeButton.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
            return cell
        }
    }
    
    @objc
    private func xmarkImageTapped(sender: UITapGestureRecognizer) {
        print(#function)
        guard let view = sender.view else { return }
        searchTexts.remove(at: view.tag)
        mainView.recentSearchCollectionView.reloadData()
    }
    
    @objc
    private func likeButtonTapped(sender: UIButton) {
        let movieID = trendMovies[sender.tag].id
        sender.isSelected.toggle()
        if sender.isSelected {
            likedMovies.insert(movieID)
        } else {
            likedMovies.remove(movieID)
        }
        NotificationManager.center.post(name: .movieLike,
                                        object: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == mainView.recentSearchCollectionView {
            let vc = SearchMainViewController()
            vc.searchText = searchTexts[indexPath.item]
            navigationController?.pushViewController(vc, animated: true)
        } else {
            // 추천 영화
            let movie = trendMovies[indexPath.item]
            let isLiked = likedMovies.contains(movie.id)
            let vc = DetailMainViewController(movie: movie, isLiked: isLiked) {
                /*UIView.performWithoutAnimation { */[weak self] in
                    guard let self else { return }
                    likedMovies = UserDefaultsManager.likedMovies ?? []
                    mainView.movieCollectionView.reloadItems(at: [indexPath])
//                }
            }
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
