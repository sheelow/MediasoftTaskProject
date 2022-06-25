//
//  TableViewViewModel.swift
//  MediasoftTaskProject
//
//  Created by Artem Shilov on 25.06.2022.
//

import Foundation

class TableViewViewModel: TableViewViewModelProtocol {
    
    var profiles = [
        Profile(name: "Dave", secondName: "Winnel",description: "Some description", photo: "fakeava"),
        Profile(name: "Paul", secondName: "Fisher", description: "Some description", photo: "fakeava"),
        Profile(name: "Chris", secondName: "Lake",description: "Some description", photo: "fakeava"),
        Profile(name: "Martin", secondName: "Garrix", description: "Some description", photo: "fakeava"),
        Profile(name: "Sebastian", secondName: "Bennet",description: "Some description", photo: "fakeava"),
        Profile(name: "James", secondName: "Hype", description: "Some description", photo: "fakeava"),
        Profile(name: "Sonny", secondName: "Fodera", description: "Some description", photo: "fakeava")
    ]
    
    func numberOfRows() -> Int {
        profiles.count
    }
    
    func cellViewModel(forIndexPath indexPath: IndexPath) -> TableViewCellViewModelProtocol? {
        let profile = profiles[indexPath.row]
        return TableViewCellViewModel(profile: profile)
    }
    
}
