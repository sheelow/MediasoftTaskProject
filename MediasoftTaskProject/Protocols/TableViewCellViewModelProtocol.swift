//
//  TableViewCellViewModelProtocol.swift
//  MediasoftTaskProject
//
//  Created by Artem Shilov on 25.06.2022.
//

import Foundation

protocol TableViewCellViewModelProtocol: AnyObject {
    var fullName: String { get }
    var description: String { get }
    var photo: String { get }
}
