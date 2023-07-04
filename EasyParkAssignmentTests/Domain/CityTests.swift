//
//  CityTests.swift
//  EasyParkAssignmentTests
//
//  Created by Swathi on 2023-07-04.
//

import XCTest
import MapKit
@testable import EasyParkAssignment

final class CityTests: XCTestCase {

    func testCityEntity() {
        let sut = City.mockCity1()
        XCTAssertNotNil(sut.id)
    }

    func testCoordinateRegion() {
        let sut = City.mockCity1()
        XCTAssertEqual(sut.coordinateRegion.center.latitude, City.mockCity1().lat)
        XCTAssertEqual(sut.coordinateRegion.center.longitude, City.mockCity1().lon)
    }
    
    func testMapCoordinates() {
        let sut = City.mockCity1()
        XCTAssertFalse(sut.mapCoordinates().isEmpty)
        let coordinatePoints = sut.points.components(separatedBy: ",")
        XCTAssertEqual(sut.mapCoordinates().count, coordinatePoints.count)
    }
    
    func testBoundaryPoints() {
        let sut = City.mockCity1()
        XCTAssertNotNil(sut.boundaryPoints)
        let coordinatePoints = sut.points.components(separatedBy: ",")
        XCTAssertEqual(coordinatePoints.count, sut.boundaryPoints.pointCount)
    }
    
}
