//
//  APIService.swift
//  MagicBall
//
//  Created by artem on 08.11.2023.
//

import UIKit
import Alamofire

// MARK: - config forURL
struct Config {
    static let baseUrl = "https://2llctw8ia5.execute-api.us-west-1.amazonaws.com/prod"
}

// MARK: - create APIService
final class APIService {
    func fetchData(completion: @escaping (Result<ModelForDataRemote, Error>) -> Void) {
        AF.request(Config.baseUrl).responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    let model = try decoder.decode(ModelForDataRemote.self, from: data)
                    completion(.success(model))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
