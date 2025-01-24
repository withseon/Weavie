//
//  BaseViewController.swift
//  Weavie
//
//  Created by 정인선 on 1/24/25.
//

import UIKit

class BaseViewController: UIViewController {
    override func viewDidLoad() {
        configureUI()
        configureNavigation()
    }
    
    private func configureUI() {
        configureHierarchy()
        configureLayout()
        configureView()
    }
    
    func configureHierarchy() { }
    func configureLayout() { }
    func configureView() { }
    func configureNavigation() { }
}
