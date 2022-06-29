//
//  MainTabBarController.swift
//  MediasoftTaskProject
//
//  Created by Artem Shilov on 25.06.2022.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabBar()
    }
    
    private func configureTabBar() {
        tabBar.backgroundColor = .white
        
        let tableViewPresenter: TableViewPresenterProtocol = TableViewPresenter()
        let tableViewNavigationController = UINavigationController(rootViewController: TableViewController(presenter: tableViewPresenter))
        let collectionViewPresenter: CollectionViewPresenterProtocol = CollectionViewPresenter()
        let collectionViewNavigationController = UINavigationController(rootViewController: CollectionViewController(presenter: collectionViewPresenter))
        
        viewControllers = [tableViewNavigationController, collectionViewNavigationController]
        
        tableViewNavigationController.tabBarItem = UITabBarItem(title: "TableView", image: .init(systemName: "list.bullet.rectangle"), tag: 0)
        collectionViewNavigationController.tabBarItem = UITabBarItem(title: "Favourites", image: .init(systemName: "star"), tag: 1)
    }
}
