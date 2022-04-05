//
//  Request.swift
//  MyChat
//
//  Created by Konstantin Porokhov on 21.04.2021.
//

import Foundation

final class WeatherRequest: IRequest {

    enum DaysCount: String {
        case one = "CurrentWeatherUrl"
        case four = "FourDayWeatherUrl"
    }

    private let cordsEntity: CordsEntity
    private let daysCount: DaysCount

    init(cordsEntity: CordsEntity, daysCount: DaysCount) {
        self.cordsEntity = cordsEntity
        self.daysCount = daysCount
    }

    private var urlString: String? {
        let param = "&lat=\(cordsEntity.lat)&lon=\(cordsEntity.lon)"
        guard let url = Bundle.main.object(forInfoDictionaryKey: daysCount.rawValue) as? String else { return nil }
        let urlString = url + param
        return urlString
    }

    var urlRequest: URLRequest? {
        guard let url = URL(string: urlString ?? "") else { return nil }
        return URLRequest(url: url)
    }

}
