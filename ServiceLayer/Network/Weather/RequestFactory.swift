//
//  RequestFactory.swift
//  MyChat
//
//  Created by Konstantin Porokhov on 21.04.2021.
//

import Foundation

struct RequestFactory {

    struct WeatherRequests {

        static func loadWeather(with coords: CordsEntity) -> RequestConfig<WeatherParser> {
            let request = WeatherRequest(cordsEntity: coords, daysCount: .one)
            let parser = WeatherParser()

            return RequestConfig<WeatherParser>(request: request, parser: parser)
        }

        static func loadWeatherDaily(with coords: CordsEntity) -> RequestConfig<WeatherDailyParser> {
            let request = WeatherRequest(cordsEntity: coords, daysCount: .four)
            let parser = WeatherDailyParser()

            return RequestConfig<WeatherDailyParser>(request: request, parser: parser)
        }

    }

}
