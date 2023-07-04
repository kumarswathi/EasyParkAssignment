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

    let selectedCity: City
   
    func makeUIView(context: Self.Context) -> MKMapView {
        let mapView = MKMapView(frame: .zero)
        mapView.delegate = context.coordinator
        mapView.showsUserLocation = true
        mapView.showsTraffic = false
        mapView.setRegion(coordinateRegion, animated: true)
        return mapView
    }
    
    func mapCoordinates() -> [CLLocationCoordinate2D] {
        let coordinatePoints = selectedCity.points.components(separatedBy: ",")
        var coordinates: [CLLocationCoordinate2D] = []
        coordinatePoints.forEach { point in
            let values = point.components(separatedBy: " ")
            if let lat = values.first, let long = values.last {
                coordinates.append(CLLocationCoordinate2D(latitude: Double(long) ?? 0.0,
                                              longitude: Double(lat) ?? 0.0))
            }
        }
        return coordinates
    }
    
    var coordinateRegion: MKCoordinateRegion {
        MKCoordinateRegion(center: .init(latitude: selectedCity.lat,
                                         longitude: selectedCity.lon),
                           span: .mediumCity)
    }
    
    func updateUIView(_ view: MKMapView, context: Self.Context) {
        
        let polygonPoints = self.mapCoordinates()
        let polygon = MKPolygon(coordinates: polygonPoints, count: polygonPoints.count)
        view.addOverlay(polygon)
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

extension MKCoordinateSpan {
    static let mediumCity = MKCoordinateSpan(latitudeDelta: 0.15,
                                             longitudeDelta: 0.15)
}
