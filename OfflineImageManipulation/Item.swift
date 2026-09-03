//
//  Item.swift
//  OfflineImageManipulation
//
//  Created by Calugar George on 03/09/2026.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
