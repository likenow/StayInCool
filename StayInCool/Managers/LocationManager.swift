//
//  LocationManager.swift
//  StayInCool
//
//  Created by kbj on 2023/7/12.
//

import Foundation
import CoreLocation
import MapKit

class LocationManager : NSObject, ObservableObject {
    let locationManager = CLLocationManager()
    @Published var authorizationStatus: CLAuthorizationStatus?
    @Published var region = MKCoordinateRegion.defaultRegion()
    
    var coordinate: CLLocationCoordinate2D {
        locationManager.location?.coordinate ?? CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
    }
    
    var latitude: Double {
        locationManager.location?.coordinate.latitude ?? 0.0
    }
    var longitude: Double {
        locationManager.location?.coordinate.longitude ?? 0.0
    }
    
    override init() {
        super.init()
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.delegate = self
        locationManager.requestLocation()

    }
}

extension LocationManager: CLLocationManagerDelegate {
    
    private func checkAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
            case .authorizedAlways:  // Location services are available.
                // Insert code here of what should happen when Location services are authorized
                authorizationStatus = .authorizedAlways
                guard let location = locationManager.location else { return }
                region = MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.25, longitudeDelta: 0.25))
                break
            
            case .authorizedWhenInUse:  // Location services are available.
                // Insert code here of what should happen when Location services are authorized
                authorizationStatus = .authorizedWhenInUse
                guard let location = manager.location else { return }
                region = MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.25, longitudeDelta: 0.25))
                break
                
            case .restricted:  // Location services currently unavailable.
                // Insert code here of what should happen when Location services are NOT authorized
                authorizationStatus = .restricted
                print("Your location is restricted.")
                break
                
            case .denied:  // Location services currently unavailable.
                // Insert code here of what should happen when Location services are NOT authorized
                authorizationStatus = .denied
                print("Your have denied app to access location services.")
                break
                
            case .notDetermined:        // Authorization not determined yet.
                authorizationStatus = .notDetermined
                manager.requestWhenInUseAuthorization()
                break
                
            default:
                break
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkAuthorization(manager)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // Insert code to handle location updates
        guard let location = locations.last else { return }
        DispatchQueue.main.async { [weak self] in
            self?.region = MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.25, longitudeDelta: 0.25))
            self?.locationManager.stopUpdatingLocation()
        }
        print("info: didUpdateLocations")
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error: \(error.localizedDescription)")
        locationManager.stopUpdatingLocation()
    }
    
    
}
