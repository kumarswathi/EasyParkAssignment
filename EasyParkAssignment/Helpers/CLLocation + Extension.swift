//
//  CLLocation + Extension.swift
//  EasyParkAssignment
//
//  Created by Swathi on 2023-07-03.
//

import Foundation
import CoreLocation
import MapKit

extension CLLocationDistance {
    
    func distanceFormatter() -> String {
        let df = MKDistanceFormatter()
        df.units = .metric
        df.unitStyle = .abbreviated
        return df.string(fromDistance: self)
    }
}
