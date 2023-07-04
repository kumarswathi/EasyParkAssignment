//
//  HomeViewModel.swift
//  EasyParkAssignment
//
//  Created by Swathi on 2023-07-02.
//

import Foundation
import CoreLocation

@MainActor
class HomeViewModel: NSObject, ObservableObject {
    @Published var cities = [City]()
    @Published var alertError: NetworkingError?
    @Published var location: CLLocation?
    @Published var selectedCity: City?
    
    let fetchCountries: FetchCountriesUseCase
    var locationService: LocationProvider
    var getLastLocation: ((CLLocation?) -> Void)?
    
    init(fetchCountries: FetchCountriesUseCase,
         locationService: LocationProvider = LocationProvider()) {
        self.fetchCountries = fetchCountries
        self.locationService = locationService
    }
    
    func onAppearAction() async {
        await loadCountries()
    }
    
    func didSelect(city: City) {
        self.selectedCity = city
    }
    
    //Request User Location only once in the app.
    func didSelectLocationButton() {
        getUserLocation()
    }
    
    func updateLocation(with value: CLLocation) {
        self.location = value
    }
    
    func distance(between userLocation: CLLocation, and city: City) -> String {
        let cityLocation = CLLocation(latitude: city.lat, longitude: city.lon)
        let distance = cityLocation.distance(from: userLocation)
        return distance.distanceFormatter()
    }
    
    private func getUserLocation() {
        locationService.reqeustForCurrentUserLocation()
        locationService.getLastLocation = { location in
            guard let userLocation = location else { return }
            self.updateLocation(with: userLocation)
        }
    }
}

// FetchCountriesUseCase

extension HomeViewModel {
    
    private func loadCountries() async {
        let result = await fetchCountries.fetchCountries()
        switch result {
        case let .success(response):
            self.cities = response.cities.removeDuplicates()
        case let .failure(error):
            alertError = error
        }
    }
}
