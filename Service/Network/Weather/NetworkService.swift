//
//  WeatherNetworkService.swift
//  MyChat
//
//  Created by Konstantin Porokhov on 21.04.2021.
//

import UIKit
import Combine

protocol WeatherNetworkService {
    func getWeather(with cordsEntity: CordsEntity, completion: @escaping (Result<WeatherRequestEntity?, Error>) -> Void)
}

final class NetworkService: WeatherNetworkService {

    // MARK: - Private Properties

    private let networkManager: RequestSenderable?
    private var cancelable: AnyCancellable?

    // MARK: - Initialization

    init(networkManager: RequestSenderable?) {
        self.networkManager = networkManager
    }

    // MARK: - Methods

    func getWeather(with cordsEntity: CordsEntity, completion: @escaping (Result<WeatherRequestEntity?, Error>) -> Void) {
        guard let urlRequest = RequestFactory.WeatherRequests.loadWeatherDaily(with: cordsEntity).urlRequest else {
            return
        }
        cancelable = networkManager?.send(request: urlRequest).sink(
            receiveCompletion: { [weak self] result in self?.handleCompletion(with: result, completion: completion) },
            receiveValue: { completion(.success($0)) }
        )
    }

}

// MARK: - Private Methods

private extension NetworkService {

    func handleCompletion(with result: Subscribers.Completion<Error>, completion: (Result<WeatherRequestEntity?, Error>) -> Void) {
        switch result {
        case .finished:
            cancelable?.cancel()
        case .failure(let error):
            completion(.failure(error))
        }
    }

}
