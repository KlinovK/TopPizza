//
//  Item.swift
//  TopPizza
//
//  Created by Константин Клинов on 24/07/25.
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
