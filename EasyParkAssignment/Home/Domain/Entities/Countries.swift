//
//  Countries.swift
//  EasyParkAssignment
//
//  Created by Swathi on 2023-07-02.
//

import Foundation

struct Countries: Codable, Equatable {
    let status: String
    let cities: [City]
}

struct City: Codable, Equatable, Hashable, Identifiable {
    let name: String
    let lat, lon: Double
    let r: Int
    let points: String
    
    var id: UUID {
        UUID()
    }
}
