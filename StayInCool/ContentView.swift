//
//  ContentView.swift
//  StayInCool
//
//  Created by kbj on 2023/7/12.
//

import SwiftUI
import MapKit

struct ContentView: View {
    @EnvironmentObject var localSearchService: LocalSearchService
    @State private var search: String = ""
    @State private var showingAboutPage = false
    
    
    var body: some View {
        ZStack {
            VStack {
                Map(coordinateRegion: $localSearchService.region, showsUserLocation: true, annotationItems: localSearchService.landmarks) { landmark in
                    MapAnnotation(coordinate: landmark.coordinate) {
                        Image(systemName: "mappin")
                            .foregroundColor(localSearchService.isSelected(landmark: landmark) ? .purple: .blue)
                            .scaleEffect(localSearchService.isSelected(landmark: landmark) ? 2.2: 1.6)
                    }
                }
                .ignoresSafeArea()
                
                VStack(alignment: .leading) {
                    TextField("赶紧去找凉快地儿", text: $search, onCommit: {
                        localSearchService.search(query: search)
                    })
                    .toolbar {
                        ToolbarItemGroup(placement: .keyboard, content: {
                            // 在键盘工具栏中添加Done按钮
                            Button("隐藏") {
                                hideKeyboard()
                            }
                            Spacer()
                            Button("搜索") {
                                localSearchService.search(query: search)
                                hideKeyboard()
                            }
                        })
                    }
                    .textFieldStyle(.roundedBorder)
                    .padding()
                    
                    if !localSearchService.landmarks.isEmpty {
                        LandmarkListView()
                    }
                    // Fetch current weather
                    //                MoveButton() {
                    //                    if locationManager.authorizationStatus == .authorizedWhenInUse || locationManager.authorizationStatus == .authorizedAlways {
                    //                        // CLLocation(latitude: locationManager.latitude, longitude: locationManager.longitude)
                    //                        let loc = CLLocation(latitude: localSearchService.region.center.latitude, longitude: localSearchService.region.center.longitude)
                    //                        loadCurrentWeatherData(curLocation: loc)
                    //                    }
                    //                }
                    //                .frame(height: 60)
                }
                .onAppear {
                    localSearchService.search(query: "避暑")
                }
            }
            .onTapGesture {
                hideKeyboard()
            }
            
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        withAnimation {
                            showingAboutPage.toggle()
                        }
                    }) {
                        Image(systemName: "list.bullet")
                            .font(.title)
                            .foregroundColor(.white)
                            .padding(10)
                    }
                }
                Spacer()
            }
        }
        .sheet(isPresented: $showingAboutPage) {
            AboutPageView(isPresented: $showingAboutPage)
        }
    }
    
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(LocalSearchService())
    }
}
