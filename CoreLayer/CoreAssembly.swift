//
//  CoreAssembly.swift
//  MyChat
//
//  Created by Konstantin Porokhov on 15.04.2021.
//

import Foundation

protocol ICoreAssembly {
    var requestSender: IRequestSender { get }
}

class CoreAssembly: ICoreAssembly {
    lazy var requestSender: IRequestSender = RequestSender()
}
