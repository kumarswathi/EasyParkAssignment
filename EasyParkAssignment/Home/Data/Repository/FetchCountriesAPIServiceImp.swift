//
//  FetchCountriesServiceImp.swift
//  EasyParkAssignment
//
//  Created by Swathi on 2023-07-02.
//


import Foundation

protocol FetchCountriesService {
    func fetchCountries() async -> Result<Countries, NetworkingError>
}

class FetchCountriesAPIServiceImp: FetchCountriesService {
    private let urlSession: URLSession
    
    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }
    
    func fetchCountries() async -> Result<Countries, NetworkingError>{
        let urlRequest = URLRequest(url: URL(string: "https://pgroute-staging.easyparksystem.net/cities")!)
        do {
            let (data, urlResponse) = try await urlSession.data(for: urlRequest)
            guard let urlResponse = urlResponse as? HTTPURLResponse else {
                return .failure(.networkError(cause: "HTTPURLResponse cast error"))
            }
            guard urlResponse.statusCode == 200 else {
                return .failure(.networkError(cause: "HTTPURLResponse statusCode was not 200"))
            }
            let response = try JSONDecoder().decode(Countries.self, from: data)
            return .success(response)
        } catch {
            return .failure(.networkError(cause: error.localizedDescription))
        }
    }
}

class FetchCountriesDataServiceImpStub: FetchCountriesService {
    let result: Result<Countries, NetworkingError>
    
    init(result: Result<Countries, NetworkingError> = .success(Countries.mock())) {
        self.result = result
    }
    
    func fetchCountries() async -> Result<Countries, NetworkingError> {
        result
    }
}

