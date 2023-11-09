//
//  ResultRepository.swift
//  MagicBall
//
//  Created by artem on 08.11.2023.
//

import Foundation

final class ResultRepository: ResultRepositoryProtocol {
    
    private let apiService = APIService()
    
    // MARK: - create requestToTheServer
    func creatingRequestToTheServerToGetResult(completion: @escaping (Result<ModelForData, Error>) -> Void) {
        apiService.fetchData { result in
            switch result {
            case .success(let model):
                let resultModel = ModelForData(winner: model.winner, loser: model.loser)
                completion(.success(resultModel))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
