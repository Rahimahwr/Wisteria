//
//  OpenAIService.swift
//  Wisteria
//
//  Created by Rahimah Warsame on 16/01/2026.
//

import OpenAISwift
import Foundation

final class OpenAIService{
    
    static let shared = OpenAIService()
    
    enum Constants {
        static let key = "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"
    }
    
    
    private var client: OpenAISwift?
    private init() {}
    
    public func setup() {
        self.client = OpenAISwift(config: OpenAISwift.Config.makeDefaultOpenAI(apiKey: Constants.key))
    }
    
    public func getResponse(input: String,
                            completion: @escaping (Result<String, Error>) -> Void) {
        client?.sendCompletion(with: input, completionHandler: { result in
            switch result {
            case .success(let model):
                let output = model.choices?.first?.text ?? ""
                completion(.success(output))
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }
}

