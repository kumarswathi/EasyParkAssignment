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
    @Published var locationName: String?
    
    let manager = CLLocationManager()
    let fetchCountries: FetchCountriesUseCase

    init(fetchCountries: FetchCountriesUseCase) {
        self.fetchCountries = fetchCountries
        super.init()
        manager.delegate = self
    }

    func onAppearAction() async {
        await loadCountries()
    }
    
    func didSelectLocationButton() {
        requestLocationOnlyOnce()
    }
}

// Fetch User Location

extension HomeViewModel: CLLocationManagerDelegate {
    
    private func requestLocationOnlyOnce() {
        manager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            location.fetchCityAndCountry { cityName, _, _ in
                self.locationName = cityName
            }
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
            self.cities = response.cities
        case let .failure(error):
            alertError = error
        }
    }
}

extension CLLocation {
    func fetchCityAndCountry(completion: @escaping (_ city: String?, _ country:  String?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(self) { completion($0?.first?.locality, $0?.first?.country, $1) }
    }
}
