//
//  HomeViewModelTests.swift
//  EasyParkAssignmentTests
//
//  Created by Swathi on 2023-07-02.
//

import XCTest
@testable import EasyParkAssignment
import CoreLocation

final class HomeViewModelTests: XCTestCase {
    
    static let mockCity1 = City.mockCity1()
    static let mockCity2 = City.mockCity2()
    static let mockCountry = Countries.mock()
    
    static let dataSourceRemoteStub = FetchCountriesDataLayerStub(response: .success(mockCountry))
    static let fetchCountriesService = buildFetchCountriesRepository()
    static let fetchCountriesUseCase = FetchCountriesUseCase(source: fetchCountriesService)
    
    
    @MainActor
    func testHomeViewModel_onAppear_citiesArePopulated() async {
        let sut = makeSUT()
        await sut.onAppearAction()
        XCTAssertFalse(sut.cities.isEmpty)
    }
    
    @MainActor
    func testHomeViewModel_onAppearFetchRemoteFails_errorAlertCauseIsSet() async {
        let remoteErrorCause = "Remote Fetch failed"
        let errorNetworkError = NetworkingError.networkError(cause: remoteErrorCause)
        let dataSourceRemoteStubWithError = FetchCountriesDataLayerStub(response: .failure(errorNetworkError))
        let fetchCountriesSource = Self.buildFetchCountriesRepository(remoteSource: dataSourceRemoteStubWithError)
        let fetchCountriesUseCase = FetchCountriesUseCase(source: fetchCountriesSource)
        let sut = makeSUT(fetchCountriesUseCase: fetchCountriesUseCase)
        await sut.onAppearAction()
        XCTAssertEqual(sut.alertError, errorNetworkError)
    }
    
    @MainActor
    func testHomeViewModel_distanceBetweenCities() {
        let sut = makeSUT()
        let mockUserLocation = CLLocation(latitude: 59.4419, longitude: 18.0703)
        let distance = sut.distance(between: mockUserLocation, and: Self.mockCity1)
        XCTAssertFalse(distance.isEmpty)
    }
    
    @MainActor
    func testHomeViewModel_updateLocation() {
        let mockUserLocation = CLLocation(latitude: 59.4419, longitude: 18.0703)
        let sut = makeSUT()
        sut.updateLocation(with: mockUserLocation)
        XCTAssertEqual(sut.location, mockUserLocation)
    }
    
    @MainActor
    func testHomeViewModel_fetchCity() {
        let mockLocation = CLLocation(latitude: 59.4419, longitude: 18.0703)
        mockLocation.fetchCityAndCountry { city, country, error in
            XCTAssertNotNil(city)
        }
    }
        
    @MainActor
    func testHomeViewModel_didSelectCity() {
        let sut = makeSUT()
        sut.didSelect(city: Self.mockCity1)
        XCTAssertEqual(sut.selectedCity, Self.mockCity1)
    }
    
    @MainActor
    func testHomeViewModel_didSelectLocationButton() {
        var locationFetcher = MockLocationFetcher()
        let mockUserLocation = CLLocation(latitude: 59.4419, longitude: 18.0703)
        let requestLocationExpectation = expectation(description: "request location")
        locationFetcher.handleRequestLocation = {
            requestLocationExpectation.fulfill()
            return mockUserLocation
        }
        
        let locationProvider = LocationProvider(locationFetcher: locationFetcher)
        XCTAssertNotNil(locationProvider.locationFetcher.locationFetcherDelegate)
        
        let fetchCountriesSource = Self.buildFetchCountriesRepository()
        let fetchCountriesUseCase = FetchCountriesUseCase(source: fetchCountriesSource)
        let sut = HomeViewModel(fetchCountries: fetchCountriesUseCase, locationService: locationProvider)
        let completionExpectation = expectation(description: "completion")
        locationProvider.getLastLocation = { location in
            XCTAssertNotNil(location)
            completionExpectation.fulfill()
        }
        sut.didSelectLocationButton()
        wait(for: [requestLocationExpectation, completionExpectation], timeout: 5)
    }
    
    // MARK: - Helpers
    
    @MainActor
    private func makeSUT(
        fetchCountriesUseCase: FetchCountriesUseCase = fetchCountriesUseCase,
        file: StaticString = #file,
        line: UInt = #line
    ) -> HomeViewModel {
        let sut = HomeViewModel(fetchCountries: fetchCountriesUseCase)
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
    
    private static func buildFetchCountriesRepository(
        remoteSource: FetchCountriesDataSource = dataSourceRemoteStub
    ) -> FetchCountriesRepository {
        return FetchCountriesRepository(source: remoteSource)
    }

}
