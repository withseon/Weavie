//
//  MainTabBarController.swift
//  Weavie
//
//  Created by 정인선 on 1/25/25.
//

import UIKit

final class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabBarController()
        configureTabBarAppearance()
    }
}

extension MainTabBarController {
    private func configureTabBarController() {
        let firstNav = UINavigationController(rootViewController: CinemaMainViewController())
        let cinema = Resource.tabItem.cinema
        firstNav.tabBarItem.image = UIImage(systemName: cinema.image)
        firstNav.title = cinema.rawValue
        
        let secondNav = UINavigationController(rootViewController: UpcomingMainViewController())
        let upcoming = Resource.tabItem.upcoming
        secondNav.tabBarItem.image = UIImage(systemName: upcoming.image)
        secondNav.title = upcoming.rawValue
        
        let thirdNav = UINavigationController(rootViewController: SettingMainViewController())
        let profile = Resource.tabItem.profile
        thirdNav.tabBarItem.image = UIImage(systemName: profile.image)
        thirdNav.title = profile.rawValue
        
        setViewControllers([firstNav, secondNav, thirdNav], animated: true)
    }
    
    private func configureTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .mainBackground
        appearance.shadowColor = .clear
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
        tabBar.tintColor = .tint
    }
}
