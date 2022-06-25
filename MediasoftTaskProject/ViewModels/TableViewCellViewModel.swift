//
//  TableViewCellViewModel.swift
//  MediasoftTaskProject
//
//  Created by Artem Shilov on 25.06.2022.
//

import Foundation
 
class TableViewCellViewModel: TableViewCellViewModelProtocol {
    
    private var profile: Profile
    
    var fullName: String {
        return profile.name + " " + profile.secondName
    }
    
    var description: String {
        return profile.description
    }
    
    var photo: String {
        return profile.photo
    }
    
    init(profile: Profile) {
        self.profile = profile
    }
}
