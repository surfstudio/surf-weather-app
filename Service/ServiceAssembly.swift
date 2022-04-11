//
//  ServiceAssembly.swift
//  MyChat
//
//  Created by Konstantin Porokhov on 15.04.2021.
//

import Foundation

protocol IServicesAssembly {
    var weatherNetworkService: IWeatherNetworkService { get }
}

final class ServicesAssembly: IServicesAssembly {

    private let coreAssembly: ICoreAssembly = CoreAssembly()

    lazy var weatherNetworkService: IWeatherNetworkService = WeatherNetworkService(requestSender: coreAssembly.requestSender)

}
