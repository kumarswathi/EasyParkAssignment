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
    @Published var currentLocationName: String?
    @Published var location: CLLocation?
    
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
    
    //Request User Location only once in the app.
    func didSelectLocationButton() {
        locationService.reqeustForCurrentUserLocation()
        locationService.getLastLocation = { location in
            guard let userLocation = location else { return }
            self.location = userLocation
            /*userLocation.fetchCityAndCountry(completion: { city, country, error in
             self.currentLocationName = city
             })*/
        }
    }
    
    func distance(between userLocation: CLLocation, and city: City) -> String {
        let cityLocation = CLLocation(latitude: city.lat, longitude: city.lon)
        let distance = cityLocation.distance(from: userLocation)
        return distance.distanceFormatter()
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
