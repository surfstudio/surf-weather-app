//
//  DataBaseStorage.swift
//  SurfWeatherApp
//
//  Created by porohov on 26.05.2022.
//

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
