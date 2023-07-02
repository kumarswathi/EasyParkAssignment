//
//  FetchCountriesRepositoryTest.swift
//  EasyParkAssignmentTests
//
//  Created by Swathi on 2023-07-02.
//

import XCTest
@testable import EasyParkAssignment

final class FetchCountriesRepositoryTest: XCTestCase {
    
    static let mockCountry = Countries.mock()
    
    func testRepository_whenFetchCountries_isSuccessful() async {
        let sut = makeSUT()
        let result = await sut.fetchCountries()
        XCTAssertEqual(Result.success(Self.mockCountry), result)
    }
    
    func testRepository_whenFetchCountries_returnsError() async {
        let sut = makeSUT(
            remoteSource: FetchCountriesDataLayerStub(response: .failure(.networkError(cause: "networkError")))
        )
        let result = await sut.fetchCountries()
        XCTAssertEqual(Result.failure(NetworkingError.networkError(cause: "networkError")), result)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(
        remoteSource: FetchCountriesDataSource = FetchCountriesDataLayerStub(response: .success(Countries.mock())),
        file: StaticString = #file,
        line: UInt = #line
    ) -> FetchCountriesRepository {
        let sut = FetchCountriesRepository(source: remoteSource)
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
}
