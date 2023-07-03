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
    
    let locationManager = CLLocationManager()
    let fetchCountries: FetchCountriesUseCase
    
    init(fetchCountries: FetchCountriesUseCase) {
        self.fetchCountries = fetchCountries
        super.init()
        locationManager.delegate = self
    }
    
    func onAppearAction() async {
        await loadCountries()
    }
    
    func didSelectLocationButton() {
        requestLocationOnlyOnce()
    }
    
    func distance(between userLocation: CLLocation, and city: City) -> String {
        let cityLocation = CLLocation(latitude: city.lat, longitude: city.lon)
        let distance = cityLocation.distance(from: userLocation)
        return distance.distanceFormatter()
    }
}

// Fetch User Location

extension HomeViewModel: CLLocationManagerDelegate {
    
    //Request User Location only once in the app.
    private func requestLocationOnlyOnce() {
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            self.location = location
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        alertError = NetworkingError.networkError(cause: "Update Location")
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
