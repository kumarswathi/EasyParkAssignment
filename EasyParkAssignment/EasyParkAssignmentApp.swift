//
//  EasyParkAssignmentApp.swift
//  EasyParkAssignment
//
//  Created by Swathi on 2023-06-30.
//

import SwiftUI

@main
struct EasyParkAssignmentApp: App {
    var body: some Scene {
        WindowGroup {
            HomeView(viewModel: HomeViewModel(fetchCountries: FetchCountriesUseCase()))
        }
    }
}
