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
    @State var displayMode = DisplayMode.list
    //define the columns split
    let columns = [
            GridItem(.flexible()),
            GridItem(.flexible())
    ]
    //Static demo items
    @State var images: [ImageItemModel] = (1...100).map {
        ImageItemModel(
            id: $0,
            title: "Image \($0)",
            imageURL: URL(
                string: "https://picsum.photos/id/\($0 * 10)/600/400"
            )!
        )
    }
    //    private var items: [ImageItemModel]

    var body: some View {
        NavigationStack {
            content
            .navigationTitle("Offline images demo")
            .toolbar {
                toolbar
            }
        }
    }
}

//Header view here


#Preview {
    ContentView()
    //        .modelContainer(for: ImageItemModel.self, inMemory: true)
}

