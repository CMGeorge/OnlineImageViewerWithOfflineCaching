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
    @State var networkMonitor = NetworkMonitor()
    //toast
    @State var currentToastText: String? = nil
    @State private var toastTask: Task<Void, Never>?

    var body: some View {
        NavigationStack {
            listView
            .navigationTitle("Offline images demo")
            .toolbar {
                toolbar
            }
            .safeAreaInset(edge: .top) {
                if !networkMonitor.connected {
                    CriticalBanner(message: "No internet connection")
                        .transition(.move(edge: .top).combined(with: .opacity))
                }
            }
            .overlay(alignment: .top) {
                        if let currentToastText {
                            MessageToast(text: currentToastText)
                                .transition(.move(edge: .top).combined(with: .opacity))
                        }
                    }
            .animation(.easeInOut(duration: 0.25), value: networkMonitor.connected)
            .onChange(of: networkMonitor.connected) { wasConnected, isConnected in
                if isConnected && !wasConnected {
                    showToast("Back online")
                } else if !isConnected {
                    currentToastText = nil
                }
            }
            .onChange(of: displayMode) { _, mode in
                showToast(mode == .grid ? "Grid view" : "List view")
            }

        }
    }
}

extension ContentView {
    internal func showToast(_ text: String) {
        print("should show toast with \(text)")
            toastTask?.cancel()
            currentToastText = text
            toastTask = Task {
                try? await Task.sleep(for: .seconds(2))
                guard !Task.isCancelled else { return }
                currentToastText = nil
            }
        }

}

#Preview {
    ContentView(imageListViewModel: ImageListViewModel())
    //        .modelContainer(for: ImageItemModel.self, inMemory: true)
}

