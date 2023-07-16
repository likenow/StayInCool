//
//  StayInCoolApp.swift
//  StayInCool
//
//  Created by kbj on 2023/7/12.
//

import SwiftUI

@main
struct StayInCoolApp: App {
    @StateObject private var localSearchService = LocalSearchService()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(localSearchService)
        }
    }
}
