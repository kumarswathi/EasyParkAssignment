//
//  FetchCountriesAPIServiceImpTest.swift
//  EasyParkAssignmentTests
//
//  Created by Swathi on 2023-07-02.
//

import XCTest
@testable import EasyParkAssignment

final class FetchCountriesAPIServiceImpTest: XCTestCase {

    static let mockCountry = Countries.mock()
    
    override func tearDown() {
        super.tearDown()
        URLProtocolStub.removeStub()
    }
    
    func testTodosServiceImp_whenFetchingTodosRequestSucceeds_returnsTodos() async {
        let url = URL(string: "https://mock_url/cities")!
        
        let encodedTodoList = try? JSONEncoder().encode(Self.mockCountry)
        let urlResponse = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
        URLProtocolStub.stub(data: encodedTodoList, response: urlResponse, error: nil)
        
        let sut = makeSUT()
        let result = await sut.fetchCountries()
        switch result {
        case let .success(response):
            XCTAssertEqual(response, Self.mockCountry)
        default:
            XCTFail("Request should have succeded")
        }
    }
    
    // MARK: - Helpers
    
    private func makeSUT(
        file: StaticString = #file,
        line: UInt = #line
    ) -> FetchCountriesAPIServiceImp {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [URLProtocolStub.self]
        let urlSession = URLSession(configuration: configuration)
        
        let sut = FetchCountriesAPIServiceImp(urlSession: urlSession)
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
}
