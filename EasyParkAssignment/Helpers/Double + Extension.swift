//
//  Double + Extension.swift
//  EasyParkAssignment
//
//  Created by Swathi on 2023-07-03.
//

import Foundation

extension Double {
    func distanceString() -> String {
        let distanceFormatter = MeasurementFormatter()
        distanceFormatter.unitOptions = .providedUnit
        let measurement = Measurement(value: self, unit: UnitLength.kilometers)
        return distanceFormatter.string(from: measurement)
    }
}

