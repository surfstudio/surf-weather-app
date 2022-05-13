//
//  UIApplication+Extension.swift
//  SurfWeatherApp
//
//  Created by porohov on 13.05.2022.
//

import UIKit

extension UIApplication {

    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }

}
