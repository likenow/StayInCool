//
//  LocalSearchService.swift
//  StayInCool
//
//  Created by kbj on 2023/7/14.
//

import Foundation
import MapKit
import Combine

class LocalSearchService: ObservableObject {
    @Published var region: MKCoordinateRegion = MKCoordinateRegion.defaultRegion()
    @Published var landmarks: [Landmark] = []
    @Published var selectedLandmark: Landmark?
    
    private let locationManager = LocationManager()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        setupLocationManager()
    }
    
    private func setupLocationManager() {
        locationManager.$region
            .sink { [weak self] region in
                self?.region = region
            }
            .store(in: &cancellables)
    }
    
    func search(query: String) {
        let req = MKLocalSearch.Request()
        req.naturalLanguageQuery = query
        req.region = locationManager.region
        
        let search = MKLocalSearch(request: req)
        search.start { [weak self] res, error in
            guard let self = self else { return }
            
            if let error = error {
                // Handle the error here, such as showing an alert or logging the error.
                print("Search error: \(error.localizedDescription)")
                return
            }
            
            if let res = res {
                let mapItems = res.mapItems
                let newLandmarks = mapItems.map {
                    Landmark(placemark: $0.placemark)
                }
                DispatchQueue.main.async {
                    self.landmarks = newLandmarks
                }
            }
        }
    }
    
    func selectLandmark(_ landmark: Landmark) {
        selectedLandmark = landmark
    }
    
    func isSelected(landmark: Landmark) -> Bool {
        return selectedLandmark == landmark
    }
    
    deinit {
        cancellables.forEach { $0.cancel() }
    }
}
