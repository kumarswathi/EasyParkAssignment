//
//  CoreLocationTests.swift
//  EasyParkAssignmentTests
//
//  Created by Swathi on 2023-07-03.
//

import XCTest
@testable import EasyParkAssignment
import CoreLocation

class CoreLocationTests: XCTestCase {
    
    func testReqeustForCurrentUserLocationu() {
        var locationFetcher = MockLocationProvider()
        let requestLocationExpectation = expectation(description: "request location")
        
        locationFetcher.handleRequestLocation = {
            requestLocationExpectation.fulfill()
            return CLLocation(latitude: 59.4419, longitude: 18.0703)
        }
        
        let sut = LocationProvider(locationFetcher: locationFetcher)
        XCTAssertNotNil(sut.locationFetcher.locationFetcherDelegate)
        
        let completionExpectation = expectation(description: "completion")
        sut.getLastLocation = { loc in
            XCTAssertNotNil(loc)
            completionExpectation.fulfill()
        }
        sut.reqeustForCurrentUserLocation()
        
        wait(for: [requestLocationExpectation, completionExpectation], timeout: 1)
    }
}
