//
//  ResultRepositoryProtocol.swift
//  MagicBall
//
//  Created by artem on 08.11.2023.
//

import Foundation

protocol ResultRepositoryProtocol {
    func creatingRequestToTheServerToGetResult(completion: @escaping (Result<ModelForData, Error>) -> Void)
}
