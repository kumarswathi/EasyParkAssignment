//
//  CLLocation + Extension.swift
//  EasyParkAssignment
//
//  Created by Swathi on 2023-07-03.
//

import Foundation
import CoreLocation
import MapKit

extension CLLocation {
    func fetchCityAndCountry(completion: @escaping (_ city: String?, _ country:  String?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(self) { completion($0?.first?.locality, $0?.first?.country, $1) }
    }
}

extension CLLocationDistance {
    
    func distanceFormatter() -> String {
        let df = MKDistanceFormatter()
        df.units = .metric
        df.unitStyle = .abbreviated
        return df.string(fromDistance: self)
    }
}
