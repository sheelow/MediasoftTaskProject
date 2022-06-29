//
//  DatabaseService.swift
//  MediasoftTaskProject
//
//  Created by Artem Shilov on 29.06.2022.
//

import Foundation
import SQLite

class DatabaseService {
    static let shared = DatabaseService()
    
    init() {}
    
    var model: [TableViewCellModel] = []
    
    func appendElements(profile: TableViewCellModel) {
        self.model.append(profile)
    }
}
