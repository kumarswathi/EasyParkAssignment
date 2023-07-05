//
//  HomeView.swift
//  EasyParkAssignment
//
//  Created by Swathi on 2023-07-02.
//

import SwiftUI
import CoreLocationUI
import CoreLocation

struct HomeView: View {
    @ObservedObject var viewModel: HomeViewModel
    
    var body: some View {
        VStack {
            switch viewModel.viewState {
            case .initial:
                enableLocationView
            case .locationEnabled(let userLocation, let cities):
                List {
                    Section(content: {
                        ForEach(cities, id: \.self) { city in
                            Button {
                                viewModel.didSelect(city: city)
                            } label: {
                                HStack {
                                    Text(city.name)
                                    Spacer()
                                    Text(viewModel.distance(between: userLocation,
                                                            and: city))
                                }
                            }
                            .foregroundColor(.black)
                        }
                    }, header: {
                        HStack {
                            Text("Cities")
                            Spacer()
                            Text("Distance from User Location")
                        }
                    })
                }
            }
        }
        .alert(item: $viewModel.alertError) { error in
            Alert(title: Text(error.localizedDescription),
                  message: nil,
                  dismissButton: .cancel())
        }
        .sheet(item: $viewModel.selectedCity, content: { city in
            DetailView(selectedCity: city)
        })
        .navigationTitle("Cities")
        .task {
            await viewModel.onAppearAction()
        }
    }
    
    private var enableLocationView: some View {
        VStack {
            Text("Allow App to access device's location")
            locationButton
        }
    }
    
    private var locationButton: some View {
        LocationButton(.currentLocation) {
            viewModel.didSelectLocationButton()
        }
        .labelStyle(.iconOnly)
        .symbolVariant(.fill)
        .foregroundColor(.white)
    }
}

struct HomeView_Previews: PreviewProvider {
    static let mockLocation = CLLocation(latitude: 59.4419,
                                         longitude: 18.0703)
    static let source = FetchCountriesRepositoryStub()
    static let useCase = FetchCountriesUseCase(source: source)
    static let homeViewModelInitial = HomeViewModel(fetchCountries: useCase, viewState: .initial)
    static let homeViewModelLocation = HomeViewModel(fetchCountries: useCase,
                                                     viewState: .locationEnabled(mockLocation,
                                                                                 [.mockCity1(), .mockCity2()]))
    static var previews: some View {
        HomeView(viewModel: homeViewModelInitial)
        HomeView(viewModel: homeViewModelLocation)
    }
}
