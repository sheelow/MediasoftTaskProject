//
//  TableViewViewModel.swift
//  MediasoftTaskProject
//
//  Created by Artem Shilov on 25.06.2022.
//

import Foundation

class TableViewViewModel: TableViewViewModelProtocol {
    
    var profiles = [
        Profile(name: "Artem", secondName: "Shilov",description: "Some description", photo: "fakeava"),
        Profile(name: "Sergey", secondName: "Kutsuev", description: "Some description", photo: "fakeava"),
        Profile(name: "Alex", secondName: "Rich", description: "Some description", photo: "fakeava")
    ]
    
    func numberOfRows() -> Int {
        profiles.count
    }
    
    func cellViewModel(forIndexPath indexPath: IndexPath) -> TableViewCellViewModelProtocol? {
        let profile = profiles[indexPath.row]
        return TableViewCellViewModel(profile: profile)
    }
    
    
}
