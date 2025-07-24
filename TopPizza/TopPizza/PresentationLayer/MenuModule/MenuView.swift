//
//  MenuView.swift
//  TopPizza
//
//  Created by Константин Клинов on 24/07/25.
//

import SwiftUI

struct MenuView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var menuItems: [MenuItem] = []
    @State private var selectedRegion = "New York"
    private let presenter = MenuPresenter()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Region selector
                    Picker("Region", selection: $selectedRegion) {
                        Text("New York").tag("New York")
                        Text("Los Angeles").tag("Los Angeles")
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal)
                    
                    // Banners
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(0..<3) { _ in
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.orange.opacity(0.3))
                                    .frame(width: 200, height: 100)
                                    .overlay(Text("Banner"))
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    // Categories
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(["Pizza", "Salad", "Drink"], id: \.self) { category in
                                Button(category) {}
                                    .padding()
                                    .background(Color.gray.opacity(0.2))
                                    .cornerRadius(10)
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    // Menu Items
                    ForEach(groupedItems, id: \.key) { category, items in
                        Section(header: Text(category).font(.headline)) {
                            ForEach(items) { item in
                                HStack {
                                    Text(item.name)
                                    Spacer()
                                    Text("$\(item.price, specifier: "%.2f")")
                                }
                                .padding()
                                .background(Color.white)
                                .cornerRadius(10)
                                .padding(.horizontal)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Menu")
            .onAppear {
                presenter.fetchMenuItems { items in
                    menuItems = items
                }
            }
        }
    }
    
    private var groupedItems: [(key: String, value: [MenuItem])] {
        Dictionary(grouping: menuItems, by: { $0.category })
            .sorted { $0.key < $1.key }
    }
}

#Preview {
    MenuView()
}
