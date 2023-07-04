//
//  DetailView.swift
//  EasyParkAssignment
//
//  Created by Swathi on 2023-07-04.
//

import SwiftUI

struct DetailView: View {
    var selectedCity: City
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: { presentationMode.wrappedValue.dismiss() },
                       label: { Image(systemName: "xmark")
                })
            }
            MapViewRepresentable(selectedCity: selectedCity)
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(selectedCity: City.mockCity2())
    }
}
