//
//  TopPizzaApp.swift
//  TopPizza
//
//  Created by Константин Клинов on 24/07/25.
//

import SwiftUI
import SwiftData
import Security

@main
struct FoodDeliveryApp: App {
    
    let modelContainer: ModelContainer
    
    init() {
        do {
            modelContainer = try ModelContainer(for: MenuItem.self)
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            SplashView()
                .modelContainer(modelContainer)
        }
    }
}
