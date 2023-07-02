//
//  FetchCountriesDataSource.swift
//  EasyParkAssignment
//
//  Created by Swathi on 2023-07-02.
//


import Foundation

protocol FetchCountriesDataSource {
    func fetchCountries() async -> Result<Countries, NetworkingError>
}

class FetchCountriesDataLayer: FetchCountriesDataSource {
    
    let service: FetchCountriesService
    
    init(service: FetchCountriesService = FetchCountriesAPIServiceImp()) {
        self.service = service
    }
    
    func fetchCountries() async -> Result<Countries, NetworkingError> {
        let response = await service.fetchCountries()
        switch response {
        case let .success(countries):
            return .success(countries)
        case let .failure(error):
            return .failure(error)
        }
    }
}

class FetchCountriesDataLayerStub: FetchCountriesDataSource {
    let response: Result<Countries, NetworkingError>

    init(response: Result<Countries, NetworkingError>) {
        self.response = response
    }
    
    func fetchCountries() -> Result<Countries, NetworkingError> {
        response
    }
}

