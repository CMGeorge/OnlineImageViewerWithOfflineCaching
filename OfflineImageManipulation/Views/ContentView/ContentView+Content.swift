//
//  ContentView+DataDisplay.swift
//  OfflineImageManipulation
//
//  Created by Calugar George on 03/09/2026.
//

import SwiftUI

extension ContentView {
    var listView: some View {
        LazyVStack(spacing: 12) {
            ForEach(images) { image in
                ImageCell(
                    displayAs: .list,
                    image: image
                    
                )
            }
        }
        .padding()
    }
    var gridView: some View {
        LazyVGrid(
            columns: columns,
            spacing: 12
        ) {
            ForEach(images) { image in
                ImageCell(
                    displayAs: .grid,
                    image: image
                )
            }
        }
        .padding()
        
    }
    @ViewBuilder
    var content: some View {
        ScrollView {
            switch displayMode {
            case .list:
                listView
            case .grid:
                gridView
                
            }
        }
    }
}
