//
//  CinemaMainViewController.swift
//  Weavie
//
//  Created by 정인선 on 1/25/25.
//

import UIKit

final class CinemaMainViewController: BaseViewController {
    private let mainView = CinemaMainView()
    private var searchRecord = [String: Date]() {
        willSet {
            mainView.updateSearchRecordView(isEmpty: newValue.isEmpty)
            UserDefaultsManager.searchRecord = newValue
            sortedSearchRecord = newValue.sorted(by: { $0.value > $1.value }).map { $0.key }
        }
    }
    private var sortedSearchRecord = [String]()
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
        mainView.setProfileCardGesture(gesture)
        
        self.likedMovies = likedMovies
        self.searchRecord = searchRecord
        mainView.updateProfileCardView(user: user, likedMovieCount: likedMovies.count)
    }
    
    @objc
    private func searchButtonItemTapped() {
        let vc = SearchMainViewController()
        vc.onUpdateSearchRecord = { [weak self] searchText in
            guard let self else { return }
            searchRecord[searchText] = Date.now
            mainView.recentSearchCollectionView.reloadData()
            mainView.recentSearchCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .left, animated: false)
        }
        navigationController?.pushViewController(vc, animated: true)
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

// MARK: - Network
extension CinemaMainViewController {
    private func fetchTrendMovieData() {
        TMDBManager.executeFetch(api: .trending, type: TrendMovie.self) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let success):
                trendMovies = success.results
                mainView.movieCollectionView.reloadData()
            case .failure(let failure):
                showAlert(withCancel: false, title: "네트워크 오류", message: failure.message, actionTitle: "확인")
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
        searchRecord.removeAll()
        mainView.recentSearchCollectionView.reloadData()
    }
}

// MARK: - CollectionViewDelegate, CollectionViewDataSource
extension CinemaMainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == mainView.recentSearchCollectionView {
            return searchRecord.count
        } else {
            return trendMovies.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == mainView.recentSearchCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecentSearchCollectionViewCell.identifier, for: indexPath) as? RecentSearchCollectionViewCell else { return UICollectionViewCell() }
            cell.configureContent(text: sortedSearchRecord[indexPath.item])
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
        guard let view = sender.view else { return }
        searchRecord[sortedSearchRecord[view.tag]] = nil
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
            vc.searchText = sortedSearchRecord[indexPath.item]
            vc.onUpdateSearchRecord = { [weak self] searchText in
                guard let self else { return }
                searchRecord[searchText] = Date()
                mainView.recentSearchCollectionView.reloadData()
                mainView.recentSearchCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .left, animated: false)
            }
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
                    NotificationManager.center.post(name: .movieLike,
                                                    object: nil)
//                }
            }
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
