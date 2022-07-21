//
//  MainTabBarController.swift
//  MediasoftTaskProject
//
//  Created by Artem Shilov on 25.06.2022.
//

import UIKit

final class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabBar()
    }

    private func configureTabBar() {

        let tableViewPresenter: ProfilesPresenterProtocol = ProfilesPresenter(service: NetworkService())
        let tableViewNavigationController = UINavigationController(rootViewController: ProfilesViewController(presenter: tableViewPresenter))
        let collectionViewPresenter: FavouritesPresenterProtocol = FavouritesPresenter()
        let collectionViewNavigationController = UINavigationController(rootViewController: FavouritesViewController(presenter: collectionViewPresenter))

        tableViewNavigationController.tabBarItem = UITabBarItem(
            title: "TableView",
            image: UIImage(systemName: "list.bullet.rectangle"),
            tag: 0)
        collectionViewNavigationController.tabBarItem = UITabBarItem(
            title: "Favourites",
            image: UIImage(systemName: "star"),
            tag: 1)

        viewControllers = [tableViewNavigationController, collectionViewNavigationController]

        tabBar.backgroundColor = .white
    }
}
