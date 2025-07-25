//
//  MenuPresenter.swift
//  TopPizza
//
//  Created by Константин Клинов on 24/07/25.
//

import SwiftUI
import SwiftData

struct MenuViewState {
    var menuItems: [MenuItem] = []
    var selectedCategory: String? = nil
    var selectedState: String = "CA"
    var showBanner: Bool = false
    var bannerMessage: String = ""
    var bannerType: BannerType = .success

    var groupedItems: [String: [MenuItem]] {
        Dictionary(grouping: menuItems) { $0.category }
    }

    var filteredGroupedItems: [String: [MenuItem]] {
        guard let selected = selectedCategory else { return groupedItems }
        return groupedItems.filter { $0.key == selected }
    }
}

protocol MenuPresenterProtocol {
    func fetchMenuItems(using context: ModelContext)
}

class MenuPresenter: ObservableObject, MenuPresenterProtocol {
    @Published private(set) var viewState = MenuViewState()
    
    private let remoteService: RemoteMenuServiceProtocol

    init(remoteService: RemoteMenuServiceProtocol = RemoteMenuService()) {
        self.remoteService = remoteService
    }

    func fetchMenuItems(using context: ModelContext) {
        remoteService.fetchAllMenuItems { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let items):
                    items.forEach { context.insert($0) }
                    do {
                        try context.save()
                        self?.viewState.menuItems = items
                        self?.showBanner("Logged in successfully!", type: .success)
                    } catch {
                        self?.showBanner("❌ Save error: \(error.localizedDescription)", type: .error)
                    }
                case .failure(let error):
                    self?.showBanner("❌ Fetch error: \(error.localizedDescription)", type: .error)
                }
            }
        }
    }

    func toggleCategory(_ category: String) {
        viewState.selectedCategory = (viewState.selectedCategory == category) ? nil : category
    }

    func selectState(_ state: String) {
        viewState.selectedState = state
    }

    private func showBanner(_ message: String, type: BannerType) {
        viewState.bannerMessage = message
        viewState.bannerType = type
        viewState.showBanner = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.viewState.showBanner = false
        }
    }
}
