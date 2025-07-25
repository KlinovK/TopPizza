//
//  MainTabView.swift
//  TopPizza
//
//  Created by Константин Клинов on 24/07/25.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            MenuView()
                .tabItem { Label("Menu", systemImage: "list.bullet") }
            ContactsView()
                .tabItem { Label("Contacts", systemImage: "person.2") }
            ProfileView()
                .tabItem { Label("Profile", systemImage: "person") }
            BasketView()
                .tabItem { Label("Basket", systemImage: "cart") }
        }
        .toolbar(.hidden, for: .navigationBar)
    }
}

#Preview {
    MainTabView()
}
