//
//  CoreLocationTests.swift
//  EasyParkAssignmentTests
//
//  Created by Swathi on 2023-07-03.
//

import XCTest
@testable import EasyParkAssignment
import CoreLocation


final class CoreLocationTests: XCTestCase {
    
    struct MockLocationFetcher: LocationManagerService {
        var delegate: LocationManagerOutputDelegate?
        
        // callback to provide mock locations
        var handleRequestLocation: (() -> CLLocation)?
        
        func requestLocation() {
            guard let location = handleRequestLocation?() else { return }
            delegate?.locationFetcher(self, didUpdateLocations: [location])
        }
    }
    
    
    func testLocationProvider_fetchUserLocation() {
        var locationFetcher = MockLocationFetcher()
        let requestLocationExpectation = expectation(description: "request location")
        
        locationFetcher.handleRequestLocation = {
            requestLocationExpectation.fulfill()
            return CLLocation(latitude: 37.3293, longitude: -121.8893)
        }
        let locationProvider = LocationProvider(locationFetcher: locationFetcher)
        XCTAssertNotNil(locationProvider.locationFetcher.locationFetcherDelegate)
        
        let completionExpectation = expectation(description: "completion")
        locationProvider.getLastLocation = { loc in
            XCTAssertNotNil(loc)
            completionExpectation.fulfill()
        }
        
        locationProvider.requestCurrentLocationOfUser()
        
        wait(for: [requestLocationExpectation, completionExpectation], timeout: 1)
        
    }
}
