//
//  NetworkService.swift
//  MediasoftTaskProject
//
//  Created by Artem Shilov on 27.06.2022.
//

import Foundation
import Alamofire

class NetworkService {
    
    func getTocken(code: String, completion: @escaping (Token) -> Void) {
        
        let parameters: [String: Any] = [
            "client_id": Constants.clientID,
            "client_secret": Constants.clientSecret,
            "redirect_uri": Constants.redirectURL,
            "code": "\(code)",
            "grant_type": Constants.authorizationCode
        ]
        
        AF.request("https://unsplash.com/oauth/token", method: .post, parameters: parameters).response { data in
            switch data.result {
            case .success(let data):
                if let data = data {
                    if let result = try? JSONDecoder().decode(Token.self, from: data) {
                        completion(result)
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func fetchData(page: Int, _ completion: @escaping ([ResultPhoto]) -> Void) {
        
        let parameters: [String: Any] = [
            "page": page,
            "per_page": 10,
            "query": "people",
            "client_id": Constants.clientID
        ]
        
        AF.request("https://api.unsplash.com/search/photos", method: .get, parameters: parameters).response { data in
            switch data.result {
            case .success(let data):
                if let data = data {
                    if let result = try? JSONDecoder().decode(Profile.self, from: data) {
//                        print(result.results)
                        completion(result.results)
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
