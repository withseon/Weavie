//
//  SearchMainViewController.swift
//  Weavie
//
//  Created by 정인선 on 1/25/25.
//

import UIKit

final class SearchMainViewController: BaseViewController {
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
            searchParam.query = searchText
            fetchSearchMovieData()
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.55) { [weak self] in
                guard let self else { return }
                navigationItem.searchController?.searchBar.becomeFirstResponder()
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        navigationItem.searchController?.searchBar.resignFirstResponder()
    }
    
    override func configureNavigation() {
        super.configureNavigation()
        navigationItem.title = Resource.NavTitle.search.rawValue
        let searchController = UISearchController()
        searchController.searchBar.placeholder = Resource.Placeholder.searchMovie.rawValue
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.automaticallyShowsCancelButton = false
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
}

// MARK: - Network
extension SearchMainViewController {
    private func fetchSearchMovieData() {
        TMDBManager.executeFetch(api: .search(searchParam), type: SearchMovie.self) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let success):
                guard success.totalResults > 0 else {
                    mainView.showEmptyLabel(isDataEmpty: true)
                    return
                }
                mainView.showEmptyLabel(isDataEmpty: false)
                if searchParam.page == 1 {
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
                showAlert(withCancel: false, title: "네트워크 오류", message: failure.message, actionTitle: "확인")
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
        guard let text = searchBar.text?.trimmingCharacters(in: .whitespaces),
              text.count >= 1  else {
            showAlert(withCancel: false, title: "입력 오류", message: "한 글자 이상 검색해주세요.", actionTitle: "확인")
            return
        }
        if searchParam.query != text {
            searchParam.page = 1
            searchParam.query = text
            onUpdateSearchRecord?(text)
            fetchSearchMovieData()
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
        if indexPath.row == searchParam.page * 20 - 2 {
            searchParam.page += 1
            if searchParam.page <= totalPage {
                fetchSearchMovieData()
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
