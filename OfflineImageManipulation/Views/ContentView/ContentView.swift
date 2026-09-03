//
//  ContentView.swift
//  OfflineImageManipulation
//
//  Created by Calugar George on 03/09/2026.
//

import SwiftData
import SwiftUI

enum DisplayMode {
    case list
    case grid
}

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    
    @State var imageListViewModel: ImageListViewModel

    @State var displayMode = DisplayMode.list

    var body: some View {
        NavigationStack {
            listView
            .navigationTitle("Offline images demo")
            .toolbar {
                toolbar
            }
        }
    }
}

//Header view here


#Preview {
    ContentView(imageListViewModel: ImageListViewModel())
    //        .modelContainer(for: ImageItemModel.self, inMemory: true)
}

