//
//  AddSitiesView.swift
//  SurfWeatherApp
//
//  Created by porohov on 11.05.2022.
//

import SwiftUI

struct AddSitiesView: View {

    var body: some View {
        VStack(alignment: .center, spacing: 18.0) {
            Text("Добавлен новый город \n Выберете его чтобы сделать главным.")
                .font(.system(size: 12, weight: .medium, design: .default))
                .multilineTextAlignment(.center)
            VStack(alignment: .leading, spacing: 22.0) {
                Text("Выберете место")
                    .font(.system(size: 24, weight: .heavy))
                    .multilineTextAlignment(.leading)
                Text("Отслеживайте погоду в родном городе и, отправляясь в путешевствие")
            }
        }
    }

}

struct AddSitiesView_Previews: PreviewProvider {
    static var previews: some View {
        AddSitiesView()
    }
}
