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
            //view mode button
            Button (action: swapViewMode) {
                Image(
                    systemName: displayMode == .grid
                        ? "list.bullet"
                        : "square.grid.2x2"
                )
            }
            .accessibilityLabel(Text("Switch View Mode"))
            .accessibilityHint(Text("Switch between list and grid view"))
            .accessibilityValue(Text(displayMode == .grid ? "Grid" : "List"))
            
            //refresh button
            Button (action: refresh){
                Image(systemName: "arrow.clockwise")
            }
            .accessibilityLabel(Text("Refresh"))
            .accessibilityHint(Text("Refresh the list"))
            
        }
    }
    
}
//Button actions
extension ContentView {
    //switch the mode on press
    private func swapViewMode(){
        withAnimation(.easeInOut(duration: 0.25)) {
            displayMode =
                displayMode == .grid
                ? .list
                : .grid
        }
    }
    private func refresh() {
        print("Refresh needed")
        Task{
            await imageListViewModel.changeImageList()
        }
    }
}
#Preview {
    ContentView(imageListViewModel: ImageListViewModel())
    //        .modelContainer(for: ImageItemModel.self, inMemory: true)
}
