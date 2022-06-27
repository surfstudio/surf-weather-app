//
//  RequestSenderable.swift
//  MyChat
//
//  Created by Konstantin Porokhov on 21.04.2021.
//

import Foundation
import Combine

protocol RequestSenderable {
    func send<Model: Codable>(request: URLRequest) -> AnyPublisher<Model, Error>
}
