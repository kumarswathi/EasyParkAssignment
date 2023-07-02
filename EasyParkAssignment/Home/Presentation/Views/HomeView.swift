//
//  HomeView.swift
//  EasyParkAssignment
//
//  Created by Swathi on 2023-07-02.
//


import SwiftUI

struct HomeView: View {
    @ObservedObject var viewModel: HomeViewModel
    
    var body: some View {
        List {
            ForEach(viewModel.cities, id: \.name) { city in
                HStack {
                    Text(city.name)
                    Spacer()
                }
            }
        }
        .sheet(item: $viewModel.alertError) { error in
            Text(error.localizedDescription)
        }
        .navigationTitle("Cities")
        .task {
            await viewModel.onAppearAction()
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static let source = FetchCountriesRepositoryStub()
    static let useCase = FetchCountriesUseCase(source: source)
    static let homeViewModel = HomeViewModel(fetchCountries: useCase)
    
    static var previews: some View {
        NavigationStack {
            HomeView(viewModel: homeViewModel)
        }
    }
}
