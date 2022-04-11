//
//  RequestFactory.swift
//  MyChat
//
//  Created by Konstantin Porokhov on 21.04.2021.
//

import Foundation

struct RequestFactory {

    struct WeatherRequests {

        static func loadWeatherDaily(with coords: CordsEntity) -> RequestConfig<WeatherParser> {
            let request = WeatherRequest(cordsEntity: coords)
            let parser = WeatherParser()

            return RequestConfig<WeatherParser>(request: request, parser: parser)
        }

    }

}
