//
//  HomeViewModel.swift
//  EasyParkAssignment
//
//  Created by Swathi on 2023-07-02.
//

import Foundation

@MainActor
class HomeViewModel: ObservableObject {
    @Published var cities = [City]()
    @Published var alertError: NetworkingError?
    
    let fetchCountries: FetchCountriesUseCase

    init(fetchCountries: FetchCountriesUseCase) {
        self.fetchCountries = fetchCountries
    }

    func onAppearAction() async {
        await loadCountries()
    }
    
    private func loadCountries() async {
        let result = await fetchCountries.fetchCountries()
        switch result {
        case let .success(response):
            self.cities = response.cities
        case let .failure(error):
            alertError = error
        }
    }
}
