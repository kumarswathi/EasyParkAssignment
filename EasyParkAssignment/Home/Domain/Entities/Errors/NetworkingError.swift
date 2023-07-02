//
//  NetworkingError.swift
//  EasyParkAssignment
//
//  Created by Swathi on 2023-07-02.
//

import Foundation

import Foundation

enum NetworkingError: Error, Hashable, Identifiable, Equatable, LocalizedError {
    var id: Self { self }
    
    case networkError(cause: String)
    
    var errorDescription: String? {
        switch self {
        case .networkError(let cause):
            return cause
        }
    }
}
