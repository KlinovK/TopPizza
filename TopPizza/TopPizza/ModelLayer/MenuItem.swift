//
//  MenuItem.swift
//  TopPizza
//
//  Created by Константин Клинов on 24/07/25.
//

import Foundation
import SwiftData

@Model
class MenuItem: Identifiable {
    var id: String
    var name: String
    var price: Double
    var category: String
    
    init(id: String, name: String, price: Double, category: String) {
        self.id = id
        self.name = name
        self.price = price
        self.category = category
    }
}
