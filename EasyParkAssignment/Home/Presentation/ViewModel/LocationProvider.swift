//
//  LocationProvider.swift
//  EasyParkAssignment
//
//  Created by Swathi on 2023-07-03.
//

import Foundation
import CoreLocation

import Foundation
import CoreLocation

protocol LocationFetcher {
    var locationFetcherDelegate: LocationFetcherDelegate? {get set}
    func requestLocation()
}

protocol LocationFetcherDelegate {
    func locationFetcher(_ fetcher: LocationFetcher, didUpdateLocations locations: [CLLocation])
}

extension CLLocationManager: LocationFetcher {
    var locationFetcherDelegate: LocationFetcherDelegate? {
        get {
            return delegate as! LocationFetcherDelegate?
        }
        set {
            delegate = newValue as! CLLocationManagerDelegate?
        }
    }
}

class LocationProvider: NSObject {
    
    var locationFetcher: LocationFetcher
    var getLastLocation: ((CLLocation?) -> Void)?
    
    init(locationFetcher: LocationFetcher = CLLocationManager()) {
        self.locationFetcher = locationFetcher
        super.init()
        self.locationFetcher.locationFetcherDelegate = self
    }
    
    func reqeustForCurrentUserLocation() {
        locationFetcher.requestLocation()
    }
}

extension LocationProvider: LocationFetcherDelegate {
    func locationFetcher(_ fetcher: LocationFetcher, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            self.getLastLocation?(location)
        }
    }
}

extension LocationProvider: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationFetcher(manager, didUpdateLocations: locations)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        getLastLocation?(nil)
    }
}
