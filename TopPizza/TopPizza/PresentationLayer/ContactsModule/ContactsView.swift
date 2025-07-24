//
//  ContactsView.swift
//  TopPizza
//
//  Created by Константин Клинов on 24/07/25.
//

import SwiftUI

struct ContactsView: View {
    var body: some View {
        NavigationStack {
            Text("No contacts")
                .font(.title)
                .foregroundColor(.gray)
                .navigationTitle("Contacts")
        }
    }
}

#Preview {
    ContactsView()
}
