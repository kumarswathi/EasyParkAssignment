//
//  Array + Extension.swift
//  EasyParkAssignment
//
//  Created by Swathi on 2023-07-03.
//

import Foundation

//Remove duplicates from array
extension Array where Element:Equatable {
    func removeDuplicates() -> Array {
        return reduce(into: []) { result, element in
            if !result.contains(element) {
                result.append(element)
            }
        }
    }
}
