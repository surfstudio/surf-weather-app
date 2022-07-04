//
//  DatePickerView.swift
//  SurfWeatherApp
//
//  Created by porohov on 01.07.2022.
//

import SwiftUI

struct DatePickerView: View {

    @ObservedObject var viewModel: DatePickerViewModel
    @Binding var isShow: Bool

    var body: some View {
        VStack {
            pickerView
            buttonView
        }
    }

    var pickerView: some View {
        Picker("", selection: $viewModel.currentYear) {
            ForEach(viewModel.years, id: \.self) {
                Text($0)
            }
        }
        .pickerStyle(InlinePickerStyle())
    }

    var buttonView: some View {
        Button {
            viewModel.applyDate()
            isShow.toggle()
        } label: {
            ZStack {
                Image("big_background_light" | "big_background_dark", bundle: nil)
                    .frame(width: 212, height: 56)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                Text("Готово").foregroundColor(.white)
            }
        }
    }

}

struct DatePickerView_Previews: PreviewProvider {
    static var previews: some View {
        DatePickerView(viewModel: .init(), isShow: .constant(true))
    }
}
