//
//  CityRequest.swift
//  SurfWeatherApp
//
//  Created by porohov on 20.05.2022.
//

import Foundation

final class LocationRequest: RequestProvider {

    private let cityName: String

    init(cityName: String) {
        self.cityName = cityName.replacingOccurrences(of: " ", with: "")
    }

    private var urlString: String? {
        let param = "geocode=\(cityName)"
        guard let url = Bundle.main.object(forInfoDictionaryKey: "LocationRequestUrl") as? String else { return nil }
        let urlString = url + (param.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")

        return urlString
    }

    var urlRequest: URLRequest? {
        guard let url = URL(string: urlString ?? "") else { return nil }

        return URLRequest(url: url)
    }

}
