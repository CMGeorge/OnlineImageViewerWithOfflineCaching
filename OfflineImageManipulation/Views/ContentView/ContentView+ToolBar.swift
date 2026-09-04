//
//  ContentView+ToolBar.swift
//  OfflineImageManipulation
//
//  Created by Calugar George on 03/09/2026.
//

import SwiftUI

extension ContentView {
    @ToolbarContentBuilder
    var toolbar: some ToolbarContent {
        ToolbarItemGroup(placement: .topBarTrailing) {
            Button {
                //switch the mode on press
                withAnimation(.easeInOut(duration: 0.25)) {
                    displayMode =
                        displayMode == .grid
                        ? .list
                        : .grid
                }
            } label: {
                Image(
                    systemName: displayMode == .grid
                        ? "list.bullet"
                        : "square.grid.2x2"
                )
            }
            Button {
                refresh()
            } label: {
                Image(systemName: "arrow.clockwise")
            }
        }
    }
    private func refresh() {
        print("Refresh needed")
        Task{
            await imageListViewModel.changeImageList()
        }
    }
}
