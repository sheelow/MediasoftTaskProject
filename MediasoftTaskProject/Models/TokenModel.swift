//
//  TokenModel.swift
//  MediasoftTaskProject
//
//  Created by Artem Shilov on 27.06.2022.
//

import Foundation

struct Token: Decodable {
    let access_token: String
    let token_type: String
}
