//
//  LocationProvider.swift
//  EasyParkAssignment
//
//  Created by Swathi on 2023-07-03.
//

import Foundation
import CoreLocation

protocol LocationManagerService {
    var serviceDelegate: LocationManagerOutputDelegate? {get set}
    func requestLocation()
}

protocol LocationManagerOutputDelegate {
    func didUpdateLocation(_ manager: LocationManagerService, with locations: [CLLocation])
}

extension CLLocationManager: LocationManagerService {
    
    var serviceDelegate: LocationManagerOutputDelegate? {
        get {
            return delegate as! LocationManagerOutputDelegate?
        }
        set {
            delegate = newValue as! CLLocationManagerDelegate?
        }
    }
}
