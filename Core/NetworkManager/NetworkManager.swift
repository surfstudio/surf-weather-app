//
//  NetworkManager.swift
//  MyChat
//
//  Created by Konstantin Porokhov on 21.04.2021.
//

import Foundation
import Combine

final class NetworkManager: RequestSenderable {

    private let session = URLSession(configuration: URLSessionConfiguration.default)

    func send<Model: Codable>(request: URLRequest) -> AnyPublisher<Model, Error> {
        let request = session.dataTaskPublisher(for: request)
            .map { $0.data }
            .decode(type: Model.self, decoder: JSONDecoder())
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()

        return request
    }

}
