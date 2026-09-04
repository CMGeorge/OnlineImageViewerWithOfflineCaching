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
            .safeAreaInset(edge: .top) {
                if !imageListViewModel.networkMonitor.connected {
                    CriticalBanner(message: "No internet connection")
                        .transition(.move(edge: .top).combined(with: .opacity))
                }
            }
            .overlay(alignment: .top) {
                if let currentToastText = imageListViewModel.currentToastText {
                    MessageToast(text: currentToastText)
                                .transition(.move(edge: .top).combined(with: .opacity))
                        }
                    }
            .animation(.easeInOut(duration: 0.25), value: imageListViewModel.networkMonitor.connected)
            .onChange(of: imageListViewModel.networkMonitor.connected) { wasConnected, isConnected in
                Task {
                    await imageListViewModel.handleConnectivityChange(from: wasConnected, to: isConnected)
                }

            }
            .onChange(of: displayMode) { _, mode in
                imageListViewModel.showToast(mode == .grid ? "Grid view" : "List view")
            }

        }
    }
}

#Preview {
    ContentView(imageListViewModel: ImageListViewModel())
    //        .modelContainer(for: ImageItemModel.self, inMemory: true)
}

