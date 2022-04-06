//
//  Request.swift
//  MyChat
//
//  Created by Konstantin Porokhov on 21.04.2021.
//

import Foundation

final class WeatherRequest: IRequest {

    private let cordsEntity: CordsEntity

    init(cordsEntity: CordsEntity) {
        self.cordsEntity = cordsEntity
    }

    private var urlString: String? {
        let param = "&lat=\(cordsEntity.lat)&lon=\(cordsEntity.lon)"
        guard let url = Bundle.main.object(forInfoDictionaryKey: "WeatherRequestUrl") as? String else { return nil }
        let urlString = url + param
        return urlString
    }

    var urlRequest: URLRequest? {
        guard let url = URL(string: urlString ?? "") else { return nil }
        return URLRequest(url: url)
    }

}
