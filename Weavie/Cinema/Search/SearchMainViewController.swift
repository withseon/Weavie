//
//  SearchMainViewController.swift
//  Weavie
//
//  Created by 정인선 on 1/25/25.
//

import UIKit

class SearchMainViewController: BaseViewController {
    private let mainView = SearchMainView()
    private var likedMovies = UserDefaultsManager.likedMovies ?? [] {
        willSet {
            UserDefaultsManager.likedMovies = newValue
        }
    }
    
    private var searchParam = SearchParam()
    private var totalPage = 1
    private var page = 1
    private var resultMovies = [Movie]()
    var searchText: String?
    var onUpdateSearchRecord: ((String) -> Void)?
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        if let searchText {
            navigationItem.searchController?.searchBar.text = searchText
            fetchSearchMovieData(query: searchText, page: 1)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    override func configureNavigation() {
        super.configureNavigation()
        navigationItem.title = "영화 검색"
        let searchController = UISearchController()
        searchController.searchBar.placeholder = "영화를 검색해보세요."
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.automaticallyShowsCancelButton = false
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
}

// MARK: - Network
extension SearchMainViewController {
    private func fetchSearchMovieData(query: String, page: Int) {
        TMDBManager.executeFetch(api: .search(query: query, page: page), type: SearchMovie.self) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let success):
                guard success.totalResults > 0 else {
                    mainView.showEmptyLabel(isDataEmpty: true)
                    return
                }
                mainView.showEmptyLabel(isDataEmpty: false)
                if page == 1 {
                    totalPage = success.totalPages
                    resultMovies.removeAll()
                    resultMovies = success.results
                    mainView.movieTableView.reloadData()
                    mainView.movieTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
                } else {
                    resultMovies.append(contentsOf: success.results)
                    mainView.movieTableView.reloadData()
                }
            case .failure(let failure):
                // TODO: - Network 통신 실패 시 재시도 등
                showAlert(withCancel: false, title: "Network Error", message: failure.message, actionTitle: "확인")
            }
        }
    }
}

// MARK: - CollectionView
extension SearchMainViewController {
    private func configureTableView() {
        mainView.movieTableView.delegate = self
        mainView.movieTableView.dataSource = self
        mainView.movieTableView.register(MovieTableViewCell.self, forCellReuseIdentifier: MovieTableViewCell.identifier)
        mainView.movieTableView.rowHeight = 150
        mainView.movieTableView.separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    }
}

// MARK: - SearchBarDelegate
extension SearchMainViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text,
              text.trimmingCharacters(in: .whitespaces).count >= 2  else {
            showAlert(withCancel: false, title: "입력 오류", message: "두 글자 이상 검색해주세요.", actionTitle: "확인")
            return
        }
        searchText = text
        if let searchText {
            page = 1
            fetchSearchMovieData(query: searchText, page: page)
            onUpdateSearchRecord?(text)
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension SearchMainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = mainView.movieTableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.identifier, for: indexPath) as? MovieTableViewCell else { return UITableViewCell() }
        let movie = resultMovies[indexPath.row]
        cell.configureContent(movie: movie)
        cell.likeButton.isSelected = likedMovies.contains(movie.id)
        cell.likeButton.tag = indexPath.row
        cell.likeButton.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        return cell
    }
    
    @objc
    private func likeButtonTapped(sender: UIButton) {
        let movieID = resultMovies[sender.tag].id
        sender.isSelected.toggle()
        
        if sender.isSelected {
            likedMovies.insert(movieID)
        } else {
            likedMovies.remove(movieID)
        }
        NotificationManager.center.post(name: .movieLike,
                                                    object: nil,
                                                    userInfo: [NotificationManager.movieKey: movieID])
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == page * 20 - 2 {
            guard let searchText else { return }
            page += 1
            if page <= totalPage {
                fetchSearchMovieData(query: searchText, page: page)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movie = resultMovies[indexPath.row]
        let isLiked = likedMovies.contains(movie.id)
        let vc = DetailMainViewController(movie: movie, isLiked: isLiked) { [weak self] in
            guard let self else { return }
            likedMovies = UserDefaultsManager.likedMovies ?? []
            mainView.movieTableView.reloadRows(at: [indexPath], with: .none)
            NotificationManager.center.post(name: .movieLike,
                                                        object: nil,
                                                        userInfo: [NotificationManager.movieKey: movie.id])
        }
        navigationController?.pushViewController(vc, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
