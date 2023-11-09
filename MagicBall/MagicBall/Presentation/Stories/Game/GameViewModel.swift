//
//  GameViewModel.swift
//  MagicBall
//
//  Created by artem on 08.11.2023.
//

import Foundation

struct GameViewModelError: Error { }

final class GameViewModel {
    
    private let resultUseCase = ResultUseCase()
    var onResultUpdate: ((ModelForData) -> Void)?
    var onError: ((Error) -> Void)?
    
    func getResult() {
        resultUseCase.creatingRequestToTheServerToGetResult { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let modelData):
                    self.onResultUpdate?(modelData)
                    print(modelData)
                case .failure(let error):
                    self.onError?(error)
                    print(error)
                }
            }
        }
    }
}
