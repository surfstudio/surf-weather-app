//
//  DataBaseStorage.swift
//  SurfWeatherApp
//
//  Created by porohov on 26.05.2022.
//

import Combine

protocol WeatherStorageService {

    func getCities(completion: @escaping (Result<[CityWeatherEntity]?, Error>) -> Void)
    func saveCity(city: CityWeatherEntity, completion: @escaping (Result<Void, Error>) -> Void)
    func deleteCity(city: CityWeatherEntity, completion: @escaping (Result<Void, Error>) -> Void)

    func getWeathers(with cityName: String, completion: @escaping (Result<[StorageWeatherEntity]?, Error>) -> Void)
    func deleteWeather(with cityName: String, date: String, completion: @escaping (Result<Void, Error>) -> Void)
    func saveWeather(by city: CityWeatherEntity, weather: StorageWeatherEntity, completion: @escaping (Result<Void, Error>) -> Void)
}

final class DataBaseStorage: WeatherStorageService {

    let storageManager = CoreDataRepository<StorageWeatherEntity>()
    let cityStorageManager = CoreDataRepository<CityWeatherEntity>()

    private var cancelable: AnyCancellable?

    func getCities(completion: @escaping (Result<[CityWeatherEntity]?, Error>) -> Void) {
        cancelable = cityStorageManager.objects()
            .sink { [weak self] in self?.handleCompletion(with: $0, completion: completion)
            } receiveValue: { completion(.success($0)) }
    }

    func saveCity(city: CityWeatherEntity, completion: @escaping (Result<Void, Error>) -> Void) {
        cancelable = cityStorageManager.add({ $0 = city })
            .sink { [weak self] in self?.handleCompletion(with: $0, completion: completion)
            } receiveValue: { _ in completion(.success(())) }
    }

    func deleteCity(city: CityWeatherEntity, completion: @escaping (Result<Void, Error>) -> Void) {
        cancelable = cityStorageManager.delete(city)
            .sink { [weak self] in self?.handleCompletion(with: $0, completion: completion)
            } receiveValue: { completion(.success(())) }
    }

    func getWeathers(with cityName: String, completion: @escaping (Result<[StorageWeatherEntity]?, Error>) -> Void) {
        getCities { result in
            switch result {
            case .success(let cities):
                let city = cities?.first(where: { $0.cityName == cityName })
                completion(.success(city?.weatherArray))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func saveWeather(by city: CityWeatherEntity, weather: StorageWeatherEntity, completion: @escaping (Result<Void, Error>) -> Void) {
        city.addToWeather(weather)
        cancelable = cityStorageManager.update(city)
            .sink { [weak self] in self?.handleCompletion(with: $0, completion: completion)
            } receiveValue: { _ in completion(.success(())) }
    }

    func deleteWeather(with cityName: String, date: String, completion: @escaping (Result<Void, Error>) -> Void) {
        getCities { [weak self] result in
            switch result {
            case .success(let cities):
                guard let weather = cities?.first(where: { $0.cityName == cityName })?.weatherArray.first(where: { $0.date == date }) else {
                    return
                }
                self?.cancelable = self?.storageManager.delete(weather)
                    .sink { [weak self] in self?.handleCompletion(with: $0, completion: completion)
                    } receiveValue: { completion(.success(())) }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

}

private extension DataBaseStorage {

    func handleCompletion(with result: Subscribers.Completion<Error>, completion: (Result<Void, Error>) -> Void) {
        switch result {
        case .finished:
            cancelable?.cancel()
        case .failure(let error):
            completion(.failure(error))
        }
    }

    func handleCompletion(with result: Subscribers.Completion<Error>, completion: (Result<[CityWeatherEntity]?, Error>) -> Void) {
        switch result {
        case .finished:
            cancelable?.cancel()
        case .failure(let error):
            completion(.failure(error))
        }
    }

}
