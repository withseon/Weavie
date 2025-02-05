//
//  UpcomingMainViewController.swift
//  Weavie
//
//  Created by 정인선 on 1/25/25.
//

import UIKit

final class UpcomingMainViewController: BaseViewController {
    
    override func configureNavigation() {
        super.configureNavigation()
        navigationItem.title = Resource.NavTitle.upcoming.rawValue
    }
}
