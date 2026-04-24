//
//  NetworkManager.swift
//  GoldmanSacs
//
//  Created by Mohan Pasumarthy on 24/04/26.
//

import Foundation
import Combine

class NetworkManager {
    
    static func download(url: URL) -> AnyPublisher<Data, Error> {
        return URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: DispatchQueue.main)
            .tryMap { try handleURLResponse(output: $0) }
            .eraseToAnyPublisher()
    }
    
    static func handleURLResponse(output: URLSession.DataTaskPublisher.Output) throws -> Data {
        guard
            let response = output.response as? HTTPURLResponse,
            response.statusCode >= 200 && response.statusCode < 300 else {
            throw URLError(.badServerResponse)
        }
        return output.data
    }
    static func handleCompletion(completion: Subscribers.Completion<any Error>) {
        switch completion {
        case .finished:
            print("")
        case .failure(let error):
            print("COMPLETION: failure \(error)")
        }
    }
}
