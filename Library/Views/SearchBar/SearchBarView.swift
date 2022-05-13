//
//  SearchBarView.swift
//  SurfWeatherApp
//
//  Created by porohov on 12.05.2022.
//

import SwiftUI

struct SearchBarView: View {

    // MARK: - Properties

    @Binding var searchText: String

    // MARK: - Views

    var body: some View {
        HStack {
            Image("search", bundle: nil)
            TextField("Поиск", text: $searchText)
                .foregroundColor(Color.black | Color.white)
        }
        .font(.headline)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(Color.lightBackground2 | Color.darkBackground)
                .frame(height: 40)
        )
    }

}

struct SearchBarView_Previews: PreviewProvider {
    static var previews: some View {
        SearchBarView(searchText: .constant(""))
    }
}
