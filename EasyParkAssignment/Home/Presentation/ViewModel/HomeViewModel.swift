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
    
    //let locationManager: LocationProvider
    let fetchCountries: FetchCountriesUseCase
    
    var locationService: LocationManagerService
    var getLastLocation: ((CLLocation?) -> Void)?
    
    init(fetchCountries: FetchCountriesUseCase,
         locationService: LocationManagerService = CLLocationManager()) {
        self.fetchCountries = fetchCountries
        self.locationService = locationService
        super.init()
        self.locationService.serviceDelegate = self
    }
    
    func onAppearAction() async {
        await loadCountries()
    }
    
    //Request User Location only once in the app.
    func didSelectLocationButton() {
        locationService.requestLocation()
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

//Update ViewModel with location output
extension HomeViewModel: LocationManagerOutputDelegate {
    func didUpdateLocation(_ manager: LocationManagerService, with locations: [CLLocation]) {
        if let userLocation = locations.first {
            self.location = userLocation
            userLocation.fetchCityAndCountry(completion: { city, country, error in
                self.currentLocationName = city
            })
        }
    }
}

// Listen for Location updates with delegates

extension HomeViewModel: CLLocationManagerDelegate {
   
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        didUpdateLocation(manager, with: locations)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}
