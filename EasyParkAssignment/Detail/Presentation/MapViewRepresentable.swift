//
//  MapViewRepresentable.swift
//  EasyParkAssignment
//
//  Created by Swathi on 2023-07-04.
//

import Foundation
import SwiftUI
import UIKit
import MapKit

struct MapViewRepresentable: UIViewRepresentable {

    var selectedCity: City
   
    func makeUIView(context: Self.Context) -> MKMapView {
        let mapView = MKMapView(frame: .zero)
        mapView.delegate = context.coordinator
        mapView.showsUserLocation = true
        mapView.showsTraffic = false
        mapView.setRegion(selectedCity.coordinateRegion, animated: true)
        return mapView
    }
        
    func updateUIView(_ view: MKMapView, context: Self.Context) {
        view.addOverlay(selectedCity.boundaryPoints)
    }
    
    func makeCoordinator() -> MapViewCoordinator {
        MapViewCoordinator(self)
    }
}


extension MapViewRepresentable {
    
    class MapViewCoordinator: NSObject, MKMapViewDelegate {
        
        var mapViewController: MapViewRepresentable
        
        init(_ control: MapViewRepresentable) {
            self.mapViewController = control
        }
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = .red
            renderer.lineWidth = 2
            renderer.lineCap = .round
            renderer.lineJoin = .round
            return renderer
        }
    }
}

extension City {
  
    func mapCoordinates() -> [CLLocationCoordinate2D] {
        let coordinatePoints = points.components(separatedBy: ",")
        var coordinates: [CLLocationCoordinate2D] = []
        coordinatePoints.forEach { point in
            let values = point.components(separatedBy: " ")
            if let lat = values.first,
               let long = values.last {
                coordinates.append(CLLocationCoordinate2D(latitude: Double(long) ?? 0.0,
                                              longitude: Double(lat) ?? 0.0))
            }
        }
        return coordinates
    }
    
    var coordinateRegion: MKCoordinateRegion {
        MKCoordinateRegion(center: .init(latitude: lat,
                                         longitude: lon),
                           span: MKCoordinateSpan(latitudeDelta: 0.15,
                                                  longitudeDelta: 0.15))
    }
    
    var boundaryPoints: MKPolygon {
        MKPolygon(coordinates: mapCoordinates(),
                  count: mapCoordinates().count)
    }
}
