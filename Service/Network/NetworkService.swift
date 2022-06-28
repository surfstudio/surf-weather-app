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

protocol LocationNetworkService {
    func getLocation(with cityName: String, completion: @escaping (Result<GeocoderResponseEntry?, Error>) -> Void)
}

final class NetworkService: WeatherNetworkService, LocationNetworkService {

    // MARK: - Private Properties

    private let networkManager: RequestSenderable?
    private var clearCancelableTimer: Timer?
    private var cancelableSet = Set<AnyCancellable?>()

    // MARK: - Initialization

    init(networkManager: RequestSenderable?) {
        self.networkManager = networkManager
    }

    // MARK: - Methods

    func getWeather(with cordsEntity: CordsEntity, completion: @escaping (Result<WeatherRequestEntity?, Error>) -> Void) {
        guard let urlRequest = RequestFactory.WeatherRequests.loadWeatherDaily(with: cordsEntity).urlRequest else {
            return
        }
        let cancelable = networkManager?.send(request: urlRequest).sink(
            receiveCompletion: { [weak self] result in self?.handleCompletion(with: result, completion: completion) },
            receiveValue: { completion(.success($0)) }
        )
        stopClearCancelableSet()
        cancelableSet.insert(cancelable)
    }

    func getLocation(with cityName: String, completion: @escaping (Result<GeocoderResponseEntry?, Error>) -> Void) {
        guard let urlRequest = RequestFactory.GeocoderRequest.loadLocation(with: cityName).urlRequest else {
            return
        }
        let cancelable = networkManager?.send(request: urlRequest).sink(
            receiveCompletion: { [weak self] result in self?.handleCompletionLocation(with: result, completion: completion) },
            receiveValue: { completion(.success($0)) }
        )
        stopClearCancelableSet()
        cancelableSet.insert(cancelable)
    }

}

// MARK: - Private Methods

private extension NetworkService {

    func handleCompletion(with result: Subscribers.Completion<Error>, completion: (Result<WeatherRequestEntity?, Error>) -> Void) {
        startClearCanselableSet()

        guard case .failure(let error) = result else { return }
        completion(.failure(error))
    }

    func handleCompletionLocation(with result: Subscribers.Completion<Error>, completion: (Result<GeocoderResponseEntry?, Error>) -> Void) {
        startClearCanselableSet()

        guard case .failure(let error) = result else { return }
        completion(.failure(error))
    }

    // MARK: - Clear Requests with timeout 5 second

    func stopClearCancelableSet() {
        clearCancelableTimer?.invalidate()
    }

    func startClearCanselableSet() {
        clearCancelableTimer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { [weak self] timer in
            self?.cancelableSet.removeAll()
        }
    }

}
