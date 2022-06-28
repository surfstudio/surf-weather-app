//
//  DataBaseStorage.swift
//  SurfWeatherApp
//
//  Created by porohov on 26.05.2022.
//

import Combine
import CoreData

protocol WeatherStorageService {

    func getHourlyWeather(completion: @escaping (Result<[HourlyWeatherEntityDB]?, Error>) -> Void)
    func getWeeklyWeather(completion: @escaping (Result<[WeeklyWeatherEntityDB]?, Error>) -> Void)
    func getCities(completion: @escaping (Result<[CityWeatherEntity]?, Error>) -> Void)
    func saveCity(city: CityWeatherEntity, completion: @escaping (Result<Void, Error>) -> Void)
    func deleteCity(city: CityWeatherEntity, completion: @escaping (Result<Void, Error>) -> Void)

    func getWeathers(with cityName: String, completion: @escaping (Result<[WeeklyWeatherEntityDB]?, Error>) -> Void)
    func deleteWeather(with cityName: String, date: String, completion: @escaping (Result<Void, Error>) -> Void)
    func saveWeather(by city: CityWeatherEntity, weather: WeeklyWeatherEntityDB, completion: @escaping (Result<Void, Error>) -> Void)
}

final class DataBaseStorage: WeatherStorageService {

    let weaklyStorageManager = CoreDataRepository<WeeklyWeatherEntityDB>()
    let hourlyStorageManager = CoreDataRepository<HourlyWeatherEntityDB>()
    let cityStorageManager = CoreDataRepository<CityWeatherEntity>()

    private var clearCancelableTimer: Timer?
    private var cancelableSet = Set<AnyCancellable?>() {
        willSet { stopClearCancelableSet(with: newValue) } // Останавливает таймер если добавляются новые объекты
    }

    func getCities(completion: @escaping (Result<[CityWeatherEntity]?, Error>) -> Void) {
        let cancelable = cityStorageManager.objects()
            .sink { [weak self] in self?.handleCompletion(with: $0, completion: completion)
            } receiveValue: { completion(.success($0)) }
        cancelableSet.insert(cancelable)
    }

    func saveCity(city: CityWeatherEntity, completion: @escaping (Result<Void, Error>) -> Void) {
        let cancelable = cityStorageManager.add({ $0 = city })
            .sink { [weak self] in self?.handleCompletion(with: $0, completion: completion)
            } receiveValue: { _ in completion(.success(())) }
        cancelableSet.insert(cancelable)
    }

    func deleteCity(city: CityWeatherEntity, completion: @escaping (Result<Void, Error>) -> Void) {
        let cancelable = cityStorageManager.delete(city)
            .sink { [weak self] in self?.handleCompletion(with: $0, completion: completion)
            } receiveValue: { completion(.success(())) }
        cancelableSet.insert(cancelable)
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
        let cancelable = cityStorageManager.update(city)
            .sink { [weak self] in self?.handleCompletion(with: $0, completion: completion)
            } receiveValue: { _ in completion(.success(())) }
        cancelableSet.insert(cancelable)
    }

    func deleteWeather(with cityName: String, date: String, completion: @escaping (Result<Void, Error>) -> Void) {
        getCities { [weak self] result in
            switch result {
            case .success(let cities):
                guard let weather = cities?.first(where: { $0.cityName == cityName })?.weatherArray.first(where: { $0.date == date }) else {
                    return
                }
                let cancelable = self?.weaklyStorageManager.delete(weather)
                    .sink { [weak self] in self?.handleCompletion(with: $0, completion: completion)
                    } receiveValue: { completion(.success(())) }
                self?.cancelableSet.insert(cancelable)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func getHourlyWeather(completion: @escaping (Result<[HourlyWeatherEntityDB]?, Error>) -> Void) {
        let cancelable = hourlyStorageManager.objects()
            .sink { [weak self] in self?.handleCompletion(with: $0, completion: completion)
            } receiveValue: { completion(.success($0)) }
        cancelableSet.insert(cancelable)
    }

    func getWeeklyWeather(completion: @escaping (Result<[WeeklyWeatherEntityDB]?, Error>) -> Void) {
        let cancelable = weaklyStorageManager.objects()
            .sink { [weak self] in self?.handleCompletion(with: $0, completion: completion)
            } receiveValue: { completion(.success($0)) }
        cancelableSet.insert(cancelable)
    }

}

private extension DataBaseStorage {

    func handleCompletion(with result: Subscribers.Completion<Error>, completion: (Result<Void, Error>) -> Void) {
        startClearCanselableSet()

        guard case .failure(let error) = result else { return }
        completion(.failure(error))
    }

    func handleCompletion<T: NSManagedObject>(with result: Subscribers.Completion<Error>, completion: (Result<[T]?, Error>) -> Void) {
        startClearCanselableSet()

        guard case .failure(let error) = result else { return }
        completion(.failure(error))
    }

    // MARK: - Clear Requests with timeout 5 second

    func stopClearCancelableSet(with cancelableSet: Set<AnyCancellable?>) {
        guard cancelableSet.count > self.cancelableSet.count else { return }
        clearCancelableTimer?.invalidate()
    }

    func startClearCanselableSet() {
        clearCancelableTimer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { [weak self] timer in
            self?.cancelableSet.removeAll()
        }
    }

}
