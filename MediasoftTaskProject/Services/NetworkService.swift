//
//  NetworkService.swift
//  MediasoftTaskProject
//
//  Created by Artem Shilov on 27.06.2022.
//

import Foundation
import Alamofire

class NetworkService {
    
    enum Path {
        static let oauthToken = "https://unsplash.com/oauth/token"
        static let searchPhotos = "https://api.unsplash.com/search/photos"
    }
    
    func getTocken(code: String, completion: @escaping (Token) -> Void) {
        
        let parameters: [String: Any] = [
            "client_id": AppConstants.clientID,
            "client_secret": AppConstants.clientSecret,
            "redirect_uri": AppConstants.redirectURL,
            "code": "\(code)",
            "grant_type": AppConstants.authorizationCode
        ]
        
        AF.request(Path.oauthToken, method: .post, parameters: parameters).response { data in
            
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
            "per_page": 30,
            "query": "people",
            "client_id": AppConstants.clientID
        ]
        
        AF.request(Path.searchPhotos, method: .get, parameters: parameters).response { data in
            
            switch data.result {
            case .success(let data):
                if let data = data {
                    if let result = try? JSONDecoder().decode(Profile.self, from: data) {
                        completion(result.results)
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
