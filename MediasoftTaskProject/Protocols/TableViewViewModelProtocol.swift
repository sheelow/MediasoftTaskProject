//
//  TableViewViewModelProtocol.swift
//  MediasoftTaskProject
//
//  Created by Artem Shilov on 25.06.2022.
//

import Foundation

protocol TableViewViewModelProtocol {
    func numberOfRows() -> Int
    func cellViewModel(forIndexPath indexPath: IndexPath) -> TableViewCellViewModelProtocol?
}
