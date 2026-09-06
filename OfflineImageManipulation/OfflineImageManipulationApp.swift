//
//  OfflineImageManipulationApp.swift
//  OfflineImageManipulation
//
//  Created by Calugar George on 03/09/2026.
//

import SwiftUI
import SwiftData

@main
struct OfflineImageManipulationApp: App {
    var body: some Scene {
            WindowGroup {
            ContentView(imageListViewModel: ImageListViewModel())
        }
    }
}
