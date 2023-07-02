//
//  FetchCountriesRepository.swift
//  EasyParkAssignment
//
//  Created by Swathi on 2023-07-02.
//

import Foundation

protocol FetchCountriesDomainSource {
    func fetchCountries() async -> Result<Countries, NetworkingError>
}

class FetchCountriesRepository: FetchCountriesDomainSource {
    let source: FetchCountriesDataSource
    
    init(source: FetchCountriesDataSource = FetchCountriesDataLayer()) {
        self.source = source
    }
    
    func fetchCountries() async -> Result<Countries, NetworkingError> {
        return await source.fetchCountries()
    }
}

class FetchCountriesRepositoryStub: FetchCountriesDomainSource {
    let response: Result<Countries, NetworkingError>
    
    init(response: Result<Countries, NetworkingError> = .success(Countries.mock())) {
        self.response = response
    }
    
    func fetchCountries() async -> Result<Countries, NetworkingError> {
        response
    }
}
