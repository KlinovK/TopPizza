//
//  MenuItemDecoder.swift
//  TopPizza
//
//  Created by Константин Клинов on 25/07/25.
//

import Foundation

protocol MenuItemDecoder {
    func decode(_ data: Data, category: String) throws -> [MenuItem]
}

class DefaultMenuItemDecoder: MenuItemDecoder {
    func decode(_ data: Data, category: String) throws -> [MenuItem] {
        var items = try JSONDecoder().decode([MenuItem].self, from: data)
        items = items.map {
            MenuItem(id: $0.id, name: $0.name, price: $0.price, category: category, extra: $0.extra, img: $0.img, rate: $0.rate)
        }
        return items
    }
}
