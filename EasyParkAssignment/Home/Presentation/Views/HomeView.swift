//
//  HomeView.swift
//  EasyParkAssignment
//
//  Created by Swathi on 2023-07-02.
//

import SwiftUI
import CoreLocationUI

struct HomeView: View {
    @ObservedObject var viewModel: HomeViewModel
    
    var body: some View {
        VStack {
            if let userLocation = viewModel.location {
                List {
                    ForEach(viewModel.cities, id: \.self) { city in
                        HStack {
                            Text(city.name)
                            Spacer()
                            Text(viewModel.distance(between: userLocation, and: city))
                        }
                    }
                }
            } else {
                enableLocationView
            }
        }
        .alert(item: $viewModel.alertError) { error in
            Alert(title: Text(error.localizedDescription),
                  message: nil,
                  dismissButton: .cancel())
        }
        .navigationTitle("Cities")
        .task {
            await viewModel.onAppearAction()
        }
    }
    
    private var enableLocationView: some View {
        VStack {
            Text("Share Location to Check Distance")
            locationButton
        }
    }
    
    private var locationButton: some View {
        LocationButton(.currentLocation) {
            viewModel.didSelectLocationButton()
        }
        .labelStyle(.titleAndIcon)
    }
}

struct HomeView_Previews: PreviewProvider {
    static let source = FetchCountriesRepositoryStub()
    static let useCase = FetchCountriesUseCase(source: source)
    static let homeViewModel = HomeViewModel(fetchCountries: useCase)
    
    static var previews: some View {
        NavigationStack {
            HomeView(viewModel: homeViewModel)
        }
    }
}
