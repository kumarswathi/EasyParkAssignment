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
            if let currentLocation = viewModel.locationName {
                Text(currentLocation)
            } else {
                locationButton
            }
            
            List {
                ForEach(viewModel.cities, id: \.name) { city in
                    HStack {
                        Text(city.name)
                        Spacer()
                    }
                }
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
    
    
    private var locationButton: some View {
        LocationButton(.currentLocation) {
            viewModel.didSelectLocationButton()
        }
        .labelStyle(.iconOnly)
        .tint(.pink)
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
