//
//  DetailView.swift
//  EasyParkAssignment
//
//  Created by Swathi on 2023-07-04.
//

import SwiftUI

struct DetailView: View {
    @Environment(\.presentationMode) var presentationMode
    var selectedCity: City
    
    var body: some View {
        ZStack(alignment: .top, content: {
            MapViewRepresentable(selectedCity: selectedCity)
            
        })
        .edgesIgnoringSafeArea(.all)
        .overlay(alignment: .topTrailing, content: {
            close
                .padding(.all, 16)
        })
    }
    
    private var close: some View {
        Button(
            action: { presentationMode.wrappedValue.dismiss() },
            label: {
                Image(systemName: "xmark.square.fill")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .foregroundColor(.gray)
            })
        
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(selectedCity: City.mockCity2())
    }
}
