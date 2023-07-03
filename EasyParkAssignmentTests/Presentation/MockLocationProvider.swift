//
//  MockLocationProvider.swift
//  EasyParkAssignmentTests
//
//  Created by Swathi on 2023-07-03.
//

import Foundation
@testable import EasyParkAssignment
import CoreLocation

struct MockLocationProvider: LocationFetcher {
    var locationFetcherDelegate: LocationFetcherDelegate?
    
    // callback to provide mock locations
    var handleRequestLocation: (() -> CLLocation)?
    
    func requestLocation() {
        guard let location = handleRequestLocation?() else { return }
        locationFetcherDelegate?.locationFetcher(self, didUpdateLocations: [location])
    }
}
