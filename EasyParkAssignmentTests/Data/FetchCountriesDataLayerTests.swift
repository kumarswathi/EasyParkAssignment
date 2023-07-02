//
//  FetchCountriesDataLayerTests.swift
//  EasyParkAssignmentTests
//
//  Created by Swathi on 2023-07-02.
//

import XCTest
@testable import EasyParkAssignment

final class FetchCountriesDataLayerTests: XCTestCase {

    static let mockCountry = Countries.mock()
   
    func testRemoteDataSource_whenResultIsSuccessful_returnsCountries() async {
        let sut = makeSUT()
        let result = await sut.fetchCountries()
        switch result {
        case let .success(response):
            XCTAssertEqual(response, Self.mockCountry)
        case .failure:
            XCTFail("Request should have succeded")
        }
    }

    func testTodosRemoteDataSource_whenResultFails_returnsError() async {
        let remoteError = NetworkingError.networkError(cause: "network error")
        let serviceStub = FetchCountriesDataServiceImpStub(result: .failure(remoteError))
        let sut = makeSUT(service: serviceStub)
        let result = await sut.fetchCountries()
        switch result {
        case .success:
            XCTFail("Request should have failed")
        case let .failure(error):
            XCTAssertEqual(error, remoteError)
        }
    }
    
    // MARK: - Helpers
    
    private func makeSUT(
        service: FetchCountriesService = FetchCountriesDataServiceImpStub(),
        file: StaticString = #file,
        line: UInt = #line
    ) -> FetchCountriesDataLayer {
        let sut = FetchCountriesDataLayer(service: service)
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
}
