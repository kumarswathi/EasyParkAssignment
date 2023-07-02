//
//  FetchCountriesUseCaseTests.swift
//  EasyParkAssignmentTests
//
//  Created by Swathi on 2023-07-02.
//

import XCTest
@testable import EasyParkAssignment

final class FetchCountriesUseCaseTests: XCTestCase {

   static let mockCountry = Countries.mock()
   
    func testUseCase_whenFetchIsSuccessful_getsSuccessfulResponse() async {
        let sut = makeSUT()
        let result = await sut.fetchCountries()
        XCTAssertEqual(Result.success(Self.mockCountry), result)
    }

    func testUseCase_whenFetchFails_getsSuccessfulResponse() async {
        let source = FetchCountriesRepositoryStub(response: .failure(.networkError(cause: "unknownError")))
        let sut = makeSUT(source: source)
        let result = await sut.fetchCountries()
        XCTAssertEqual(Result.failure(.networkError(cause: "unknownError")), result)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(
        source: FetchCountriesDomainSource = FetchCountriesRepositoryStub(response: .success(Countries.mock())),
        file: StaticString = #file,
        line: UInt = #line
    ) -> FetchCountriesUseCase {
        let sut = FetchCountriesUseCase(source: source)
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }

}
