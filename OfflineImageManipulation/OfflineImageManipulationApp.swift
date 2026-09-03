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
//    var sharedModelContainer: ModelContainer = {
//        let schema = Schema([
//            ImageItemModel.self,
//        ])
//        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
//
//        do {
//            return try ModelContainer(for: schema, configurations: [modelConfiguration])
//        } catch {
//            fatalError("Could not create ModelContainer: \(error)")
//        }
//    }()

    var body: some Scene {
        WindowGroup {
            ContentView(imageListViewModel: ImageListViewModel())
        }
//        .modelContainer(sharedModelContainer)
    }
}
