//
//  Profile.swift
//  MediasoftTaskProject
//
//  Created by Artem Shilov on 25.06.2022.
//

import Foundation

struct Profile: Decodable {
    let results: [ResultPhoto]
}

struct ResultPhoto: Decodable {
    let id: String?
    let urls: Urls?
    let user: User?
    let description: String?
}

struct Urls: Decodable {
    let regular: String?
}

struct User: Decodable {
    let firstName: String?
    let lastName: String?
    
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
    }
}
