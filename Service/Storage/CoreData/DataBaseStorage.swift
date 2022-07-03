//
//  DataBaseStorage.swift
//  SurfWeatherApp
//
//  Created by porohov on 28.06.2022.
//

import Combine
import CoreData

final class DataBaseStorage: WeatherStorageService {

    // MARK: - Private Properties

    private let weaklyStorageManager = CoreDataRepository<WeeklyWeatherEntityDB>()
    private let hourlyStorageManager = CoreDataRepository<HourlyWeatherEntityDB>()
    private let cityStorageManager = CoreDataRepository<CityWeatherEntity>()

    private var clearCancelableTimer: Timer?
    private var cancelables = [AnyCancellable]() {
        willSet { stopClearCancelables() } // Останавливает таймер если добавляются новые объекты
    }

    // MARK: - Methods

    func getCities(completion: @escaping (Result<[CityWeatherEntity]?, Error>) -> Void) {
        cityStorageManager.objects().sink(
            receiveCompletion: { [weak self] in self?.handleCompletion(with: $0, completion: completion) },
            receiveValue: { completion(.success($0)) }
        ).store(in: &cancelables)
    }

    func saveCity(city: CityWeatherEntity, completion: @escaping (Result<Void, Error>) -> Void) {
        cityStorageManager.add({ $0 = city }).sink(
            receiveCompletion: { [weak self] in self?.handleCompletion(with: $0, completion: completion) },
            receiveValue: { _ in completion(.success(())) }
        ).store(in: &cancelables)
    }

    func deleteCity(city: CityWeatherEntity, completion: @escaping (Result<Void, Error>) -> Void) {
        cityStorageManager.delete(city).sink(
            receiveCompletion: { [weak self] in self?.handleCompletion(with: $0, completion: completion) },
            receiveValue: { completion(.success(())) }
        ).store(in: &cancelables)
    }

    func getWeathers(with cityName: String, completion: @escaping (Result<[WeeklyWeatherEntityDB]?, Error>) -> Void) {
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

    func saveWeather(by city: CityWeatherEntity, weather: WeeklyWeatherEntityDB, completion: @escaping (Result<Void, Error>) -> Void) {
        city.addToWeeklyWeather(weather)

        cityStorageManager.update(city).sink(
            receiveCompletion: { [weak self] in self?.handleCompletion(with: $0, completion: completion) },
            receiveValue: { _ in completion(.success(())) }
        ).store(in: &cancelables)
    }

    func deleteWeather(with cityName: String, date: Date?, completion: @escaping (Result<Void, Error>) -> Void) {
        getCities { [weak self] result in
            switch result {
            case .success(let cities):
                guard let weather = cities?.first(where: { $0.cityName == cityName })?.weatherArray.first(where: { $0.date == date }),
                      let self = self else {
                    return
                }
                self.weaklyStorageManager.delete(weather).sink(
                    receiveCompletion: { self.handleCompletion(with: $0, completion: completion) },
                    receiveValue: { completion(.success(())) }
                ).store(in: &self.cancelables)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func getHourlyWeather(completion: @escaping (Result<[HourlyWeatherEntityDB]?, Error>) -> Void) {
        hourlyStorageManager.objects().sink(
            receiveCompletion: { [weak self] in self?.handleCompletion(with: $0, completion: completion) },
            receiveValue: { completion(.success($0)) }
        ).store(in: &cancelables)
    }

    func getWeeklyWeather(completion: @escaping (Result<[WeeklyWeatherEntityDB]?, Error>) -> Void) {
        weaklyStorageManager.objects().sink(
            receiveCompletion: { [weak self] in self?.handleCompletion(with: $0, completion: completion) },
            receiveValue: { completion(.success($0)) }
        ).store(in: &cancelables)
    }

}

// MARK: - Private Methods

private extension DataBaseStorage {

    func handleCompletion(with result: Subscribers.Completion<Error>, completion: (Result<Void, Error>) -> Void) {
        startClearCanselables()

        guard case .failure(let error) = result else { return }
        completion(.failure(error))
    }

    func handleCompletion<T: NSManagedObject>(with result: Subscribers.Completion<Error>, completion: (Result<[T]?, Error>) -> Void) {
        startClearCanselables()

        guard case .failure(let error) = result else { return }
        completion(.failure(error))
    }

    // MARK: - Clear Requests with timeout 5 second

    func stopClearCancelables() {
        clearCancelableTimer?.invalidate()
    }

    func startClearCanselables() {
        clearCancelableTimer = Timer.scheduledTimer(withTimeInterval: 10, repeats: true) { [weak self] _ in
            guard self?.clearCancelableTimer?.isValid == true else { return }
            self?.cancelables.removeAll()
        }
    }

}
