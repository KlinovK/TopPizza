//
//  MenuPresenter.swift
//  TopPizza
//
//  Created by Константин Клинов on 24/07/25.
//

import Foundation
import SwiftData

protocol MenuPresenterProtocol {
    func fetchMenuItems(completion: @escaping ([MenuItem]) -> Void)
}

class MenuPresenter: MenuPresenterProtocol {
    func fetchMenuItems(completion: @escaping ([MenuItem]) -> Void) {
        // Mock API response (simulating a free food delivery API)
        let mockItems = [
            MenuItem(id: UUID().uuidString, name: "Margherita Pizza", price: 8.99, category: "Pizza"),
            MenuItem(id: UUID().uuidString, name: "Pepperoni Pizza", price: 9.99, category: "Pizza"),
            MenuItem(id: UUID().uuidString, name: "Caesar Salad", price: 5.99, category: "Salad"),
            MenuItem(id: UUID().uuidString, name: "Coke", price: 1.99, category: "Drink")
        ]
        completion(mockItems)
    }
}
