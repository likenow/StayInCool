//
//  WeatherKitManager.swift
//  StayInCool
//
//  Created by kbj on 2023/7/12.
//

import Foundation
import WeatherKit
import CoreLocation

@MainActor
class WeatherKitManager: ObservableObject {
    
    static let shared = WeatherKitManager()
    private let service = WeatherService.shared
    @Published var currentWeather: CurrentWeather?
    @Published var dailyWeather: Forecast<DayWeather>?
    var attributionInfo: WeatherAttribution?
    
    
    var symbol: String {
        currentWeather?.symbolName ?? "xmark"
    }
    
    var temp: String {
        let temp = currentWeather?.temperature
        
        let convert = temp?.converted(to: .celsius).description
        return convert ?? "获取气温..."
        
    }
    
    func updateCurrentWeather(userLocation: CLLocation) {
        Task.detached(priority: .userInitiated) {
            do {
                let forcast = try await self.service.weather(
                    for: userLocation,
                    including: .daily, .current)
                DispatchQueue.main.async {
                    self.dailyWeather = forcast.0
                    self.currentWeather = forcast.1
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func updateAttributionInfo() {
        Task.detached(priority: .background) {
            let attribution = try await self.service.attribution
            DispatchQueue.main.async {
                self.attributionInfo = attribution
            }
        }
    }
    
}
