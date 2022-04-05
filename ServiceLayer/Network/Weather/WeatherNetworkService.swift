//
//  WeatherNetworkService.swift
//  MyChat
//
//  Created by Konstantin Porokhov on 21.04.2021.
//

import UIKit

protocol IWeatherNetworkService {
    func getWeather(with cordsEntity: CordsEntity, completion: @escaping (Result<WeatherRequestEntity?, Error>) -> Void)
    func getWeatherDaily(with cordsEntity: CordsEntity, completion: @escaping (Result<WeatherDailyRequestEntity?, Error>) -> Void)
}

final class WeatherNetworkService: IWeatherNetworkService {
    
    private let requestSender: IRequestSender?
    
    init(requestSender: IRequestSender?) {
        self.requestSender = requestSender
    }

    func getWeather(with cordsEntity: CordsEntity, completion: @escaping (Result<WeatherRequestEntity?, Error>) -> Void) {
        let config = RequestFactory.WeatherRequests.loadWeather(with: cordsEntity)
        requestSender?.send(config: config) { result in
            switch result {
            case .success(let city):
                completion(.success(city))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func getWeatherDaily(with cordsEntity: CordsEntity, completion: @escaping (Result<WeatherDailyRequestEntity?, Error>) -> Void) {
        let config = RequestFactory.WeatherRequests.loadWeatherDaily(with: cordsEntity)
        requestSender?.send(config: config) { result in
            switch result {
            case .success(let city):
                completion(.success(city))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

}
