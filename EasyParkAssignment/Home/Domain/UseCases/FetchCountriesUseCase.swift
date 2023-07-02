//
//  FetchCountriesUseCase.swift
//  EasyParkAssignment
//
//  Created by Swathi on 2023-07-02.
//

class FetchCountriesUseCase {
    let source: FetchCountriesDomainSource
    
    init(source: FetchCountriesDomainSource = FetchCountriesRepository()) {
        self.source = source
    }
    
    func fetchCountries() async -> Result<Countries, NetworkingError> {
        await source.fetchCountries()
    }
}
