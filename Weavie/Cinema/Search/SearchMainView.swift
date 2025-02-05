//
//  SearchMainView.swift
//  Weavie
//
//  Created by 정인선 on 1/26/25.
//

import UIKit
import SnapKit

final class SearchMainView: BaseView {
    private let emptyLabel = UILabel()
    let movieTableView = UITableView()
    
    override func configureHierarchy() {
        addSubview(emptyLabel)
        addSubview(movieTableView)
    }
    
    override func configureLayout() {
        movieTableView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }
        emptyLabel.snp.makeConstraints { make in
            make.center.equalTo(safeAreaLayoutGuide)
        }
    }
    
    override func configureView() {
        emptyLabel.text = "원하는 검색 결과를 찾지 못했습니다."
        emptyLabel.font = .systemFont(ofSize: 14)
        emptyLabel.textColor = .subLabel
        
        emptyLabel.isHidden = true
        movieTableView.isHidden =  true
    }
}

// MARK: - UI 업데이트
extension SearchMainView {
    func showEmptyLabel(isDataEmpty: Bool) {
        emptyLabel.isHidden = isDataEmpty ? false : true
        movieTableView.isHidden = isDataEmpty ? true : false
    }
}

