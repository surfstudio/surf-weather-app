//
//  WeatherParser.swift
//  MyChat
//
//  Created by Konstantin Porokhov on 21.04.2021.
//

import Foundation

final class WeatherParser: IParser {

    typealias Model = WeatherRequestEntity

    func parse(data: Data) -> Model? {
        do {
            return try JSONDecoder().decode(Model.self, from: data)
        } catch {
            print(NetworkError.notModel.localizedDescription)
            return nil
        }
    }
}

final class WeatherDailyParser: IParser {

    typealias Model = WeatherDailyRequestEntity

    func parse(data: Data) -> Model? {
        do {
            return try JSONDecoder().decode(Model.self, from: data)
        } catch {
            print(NetworkError.notModel.localizedDescription)
            return nil
        }
    }
}
