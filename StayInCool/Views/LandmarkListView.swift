//
//  LandmarkListView.swift
//  StayInCool
//
//  Created by kbj on 2023/7/12.
//

import SwiftUI
import MapKit

struct LandmarkListView: View {
    @EnvironmentObject var localSearchService: LocalSearchService
    @State private var selectedLandmark: Landmark? = nil
    var action: ((Landmark) -> Void)?
    
    @State private var isPresenting = false
    @StateObject var locationManager = LocationManager()
    @ObservedObject var weatherKitManager = WeatherKitManager()
    
    @State private var isWeatherTaskCompleted = false
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationStack {
            List(localSearchService.landmarks) { landmark in
                HStack {
                    VStack(alignment: .leading) {
                        Text(landmark.name)
                        Text(landmark.title)
                            .opacity(0.5)
                    }
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundColor(.gray)
                }
//                        .listRowBackground(selectedLandmark == landmark ? Color.blue: Color(UIColor.lightGray))
                .contentShape(Rectangle())
                .onTapGesture {
                    DispatchQueue.main.async {
                        selectedLandmark = landmark
                        localSearchService.selectedLandmark = landmark
                        localSearchService.region = MKCoordinateRegion.regionFromLandmark(landmark)
                        //                    self.action?(landmark)
                        isPresenting = true
                    }
                }
            }
            .sheet(isPresented: $isPresenting, onDismiss: didDismiss, content: {
                VStack {
                    if let landmark = selectedLandmark {
                        VStack(alignment: .leading) {
                            HStack {
                                Text(landmark.name)
                                    .font(.title)
                                Spacer()
                                Button {
                                    isPresenting.toggle()
                                } label: {
                                    Image(systemName: "xmark")
                                        .font(.title)
                                        .foregroundColor(.blue)
                                }
                            }
                            Divider()
                            HStack {
                                Text(landmark.name)
                                Spacer()
                                Text(landmark.title)
                            }
                            .font(.subheadline)
                            .foregroundColor(.secondary)
//                            Divider()
//                            Text("About \(landmark.name)")
//                                .font(.title2)
//                            Text(landmark.title)
                        }
                        .padding()
                    }
                    Spacer()
                    if let currentWeather = weatherKitManager.currentWeather {
                        Group {
                            Form {
                                Section {
                                    Label(currentWeather.temperature.converted(to: .celsius).description, systemImage: "thermometer")
                                    Label("\(Int(currentWeather.humidity * 100))%", systemImage: "humidity.fill")
                                    // Day time Night time
                                    Label(currentWeather.isDaylight ? "白天" : "夜间", systemImage: currentWeather.isDaylight ? "sun.max.fill" : "moon.stars.fill")
                                    if let dailyWeather = weatherKitManager.dailyWeather {
                                        ForEach(dailyWeather, id: \.self.date) { weatherEntry in
                                            HStack {
                                                Image(systemName: weatherEntry.symbolName)
                                                Text("\(weatherEntry.lowTemperature.converted(to: .celsius).description) ~ \(weatherEntry.highTemperature.converted(to: .celsius).description)")
                                                Spacer()
                                                Text(DateFormatter.localizedString(from: weatherEntry.date, dateStyle: .short, timeStyle: .none))
                                            }
                                        }
                                    }
                                } header: {
                                    HStack {
                                        Spacer()
                                        Image(systemName: currentWeather.symbolName)
                                            .font(.system(size: 40))
                                        Spacer()
                                    }
                                } footer: {
                                    HStack {
                                        Spacer()
                                        VStack {
                                            if let attribution = weatherKitManager.attributionInfo {
                                                AsyncImage(url: colorScheme == .dark ? attribution.combinedMarkDarkURL : attribution.combinedMarkLightURL) { image in
                                                    image
                                                        .resizable()
                                                        .scaledToFit()
                                                        .frame(height: 20)
                                                } placeholder: {
                                                    ProgressView()
                                                }
                                                Link("数据来源", destination: attribution.legalPageURL)
                                            }
                                        }
                                        .padding()
                                        Spacer()
                                    }
                                }
                            }
                        }
                        .id(UUID())
                    } else {
                        Text("获取气温失败～")
                            .font(.subheadline)
                            .foregroundColor(.orange)
                            .padding()
                    }
                }
                .onAppear {
                    if !isWeatherTaskCompleted {
                        if locationManager.authorizationStatus == .authorizedWhenInUse || locationManager.authorizationStatus == .authorizedAlways {
                            if let landmark = selectedLandmark {
                                let reg = MKCoordinateRegion.regionFromLandmark(landmark)
                                let loc = CLLocation(latitude: reg.center.latitude, longitude: reg.center.longitude)
                                loadCurrentWeatherData(curLocation: loc)
                            }
                        }
                    }
                }
            })
            .navigationTitle("搜索结果")
        }
        .padding([.top], -20)
    }
    
    func didDismiss() {
        // Handle the dismissing action.
        isWeatherTaskCompleted = false
    }
    
    func loadCurrentWeatherData(curLocation: CLLocation) {
        if locationManager.authorizationStatus == .authorizedWhenInUse || locationManager.authorizationStatus == .authorizedAlways {
            Task.detached { @MainActor in
                weatherKitManager.updateCurrentWeather(userLocation: curLocation)
                weatherKitManager.updateAttributionInfo()
                isWeatherTaskCompleted = true
            }
        }
    }
}


struct LandmarkListView_Previews: PreviewProvider {
    static var previews: some View {
        LandmarkListView().environmentObject(LocalSearchService())
    }
}
