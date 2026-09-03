//
//  ContentView+DataDisplay.swift
//  OfflineImageManipulation
//
//  Created by Calugar George on 03/09/2026.
//

import SwiftUI

extension ContentView {
    //define the columns split
    var columns: [GridItem] {
        switch displayMode {
        case .list:
            [GridItem(.flexible())]
        case .grid:
            [GridItem(.flexible()), GridItem(.flexible())]
        }
    }
    var listView: some View {
        //dont use 2 components for data display. dynammic gridview can be enough
        ScrollView {
            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(images) { image in
                    ImageCell(displayAs: displayMode, image: image)
                        .id(image.id)
                }
            }
            .padding()
            .animation(.easeInOut(duration: 0.25), value: displayMode)
            
        }
    }
}
