//
//  MenuView.swift
//  TopPizza
//
//  Created by Константин Клинов on 24/07/25.
//

import SwiftUI
import SwiftData

struct MenuView: View {
    @Environment(\.modelContext) private var modelContext
    @ObservedObject var presenter: MenuPresenter

    private let bannerImages = ["ic_red_banner", "ic_red_banner", "ic_red_banner"]
    private let usStates = ["CA", "NY", "TX", "FL", "IL", "WA", "GA", "NC", "PA", "OH"]
    
    init(presenter: MenuPresenter = MenuPresenter()) {
        self.presenter = presenter
    }

    var body: some View {
        NavigationStack {
            ZStack(alignment: .topLeading) {
                Color(Constants.Colors.mainBackground).ignoresSafeArea()

                VStack(spacing: 0) {
                    Color.clear.frame(height: 40)

                    bannerSection
                    categorySection
                    menuListSection
                }

                stateMenu
                BannerView(
                    message: presenter.viewState.bannerMessage,
                    type: presenter.viewState.bannerType,
                    show: Binding(get: {
                        presenter.viewState.showBanner
                    }, set: { _ in })
                )
            }
            .onAppear {
                if presenter.viewState.menuItems.isEmpty {
                    presenter.fetchMenuItems(using: modelContext)
                }
            }
            .toolbar(.hidden, for: .navigationBar)
        }
    }

    private var bannerSection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(bannerImages.indices, id: \.self) { index in
                    Image(bannerImages[index])
                        .resizable()
                        .scaledToFill()
                        .frame(width: 300, height: 150)
                        .clipped()
                        .cornerRadius(10)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
        }
    }

    private var categorySection: some View {
        Group {
            if presenter.viewState.groupedItems.isEmpty {
                EmptyView()
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(presenter.viewState.groupedItems.keys.sorted(), id: \.self) { category in
                            let isSelected = presenter.viewState.selectedCategory == category

                            Button {
                                withAnimation {
                                    presenter.toggleCategory(category)
                                }
                            } label: {
                                Text(category.capitalized.replacingOccurrences(of: "-", with: " "))
                                    .font(.custom(Constants.Font.defaultFontRegular, size: 13))
                                    .foregroundColor(
                                        isSelected
                                        ? Color(Constants.Colors.mainColor)
                                        : Color(Constants.Colors.mainColor).opacity(0.4)
                                    )
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(
                                        isSelected
                                        ? Color(Constants.Colors.mainColor).opacity(0.2)
                                        : Color.white
                                    )
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(
                                                isSelected ? Color.clear : Color(Constants.Colors.mainColor).opacity(0.4),
                                                lineWidth: 1
                                            )
                                    )
                                    .cornerRadius(20)
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                }
                .background(Color(.systemGroupedBackground))
            }
        }
    }

    private var menuListSection: some View {
        Group {
            if presenter.viewState.menuItems.isEmpty {
                ProgressView("Loading menu…")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                List {
                    ForEach(presenter.viewState.filteredGroupedItems.keys.sorted(), id: \.self) { category in
                        MenuCategorySection(
                            category: category,
                            items: presenter.viewState.filteredGroupedItems[category] ?? []
                        )
                        .id(category)
                        .listRowInsets(EdgeInsets())
                    }
                }
                .listStyle(.plain)
                .scrollContentBackground(.visible)
                .background(Color.white)
            }
        }
    }

    private var stateMenu: some View {
        Menu {
            ForEach(usStates, id: \.self) { state in
                Button { presenter.selectState(state) } label: {
                    Text(state)
                }
            }
        } label: {
            HStack(spacing: 5) {
                Text(presenter.viewState.selectedState)
                    .font(.custom(Constants.Font.defaultFontRegular, size: 17))
                    .foregroundColor(Color(Constants.Colors.textColor))
                Image(systemName: "chevron.down")
                    .foregroundColor(Color(Constants.Colors.textColor))
            }
        }
        .padding(.leading, 16)
        .padding(.top, 16)
    }
}

private struct MenuCategorySection: View {
    let category: String
    let items: [MenuItem]

    var body: some View {
        Section(header: headerView) {
            ForEach(items) { item in
                MenuItemRow(item: item)
            }
        }
    }

    @ViewBuilder
    private var headerView: some View {
        EmptyView()
    }
}

private struct MenuItemRow: View {
    let item: MenuItem

    var body: some View {
        HStack(alignment: .center, spacing: 16) {
            AsyncImage(url: URL(string: item.img ?? "photo")) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(width: 132, height: 132)
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 132, height: 132)
                        .clipped()
                        .cornerRadius(12)
                case .failure:
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 132, height: 132)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(12)
                        .foregroundColor(.gray)
                @unknown default:
                    EmptyView()
                }
            }

            VStack(alignment: .trailing, spacing: 6) {
                Text(item.name)
                    .font(.custom(Constants.Font.defaultFontRegular, size: 17))
                    .foregroundColor(Color(Constants.Colors.textColor))
                    .multilineTextAlignment(.trailing)

                if let extra = item.extra {
                    Text(extra)
                        .font(.custom(Constants.Font.defaultFontRegular, size: 13))
                        .foregroundColor(Color(Constants.Colors.subtitleColor))
                        .lineLimit(2)
                        .multilineTextAlignment(.trailing)
                }

                Text(String(format: "$%.2f", item.price))
                    .font(.custom(Constants.Font.defaultFontRegular, size: 13))
                    .foregroundColor(Color(Constants.Colors.mainColor))
                    .multilineTextAlignment(.trailing)
                    .padding(.init(top: 8, leading: 18, bottom: 8, trailing: 18))
                    .frame(width: 87, height: 32)
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(Color(Constants.Colors.mainColor), lineWidth: 1)
                    )
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .frame(height: 156)
        .padding(.leading, 16)
        .padding(.trailing, 24)
        .padding(.vertical, 8)
    }
}
