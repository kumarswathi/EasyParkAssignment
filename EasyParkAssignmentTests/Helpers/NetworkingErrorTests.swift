//
//  NetworkingErrorTests.swift
//  EasyParkAssignmentTests
//
//  Created by Swathi on 2023-07-03.
//

import XCTest
@testable import EasyParkAssignment
import CoreLocation


final class NetworkingErrorTests: XCTestCase {

    func testErrorStrings() {
        let remoteErrorCause = "Remote Fetch failed"
        let errorNetworkError = NetworkingError.networkError(cause: remoteErrorCause)
        XCTAssertEqual(errorNetworkError.errorDescription, remoteErrorCause)
        XCTAssertNotNil(errorNetworkError.id)
    }
}
