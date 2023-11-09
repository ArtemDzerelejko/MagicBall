//
//  ResultUseCase.swift
//  MagicBall
//
//  Created by artem on 08.11.2023.
//

import Foundation

final class ResultUseCase {
     
    private let resultRepository: ResultRepositoryProtocol = ResultRepository()
    
    func creatingRequestToTheServerToGetResult(completion: @escaping (Result<ModelForData, Error>) -> Void) {
        resultRepository.creatingRequestToTheServerToGetResult(completion: completion)
    }
}
