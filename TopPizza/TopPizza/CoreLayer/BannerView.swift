//
//  BannerView.swift
//  TopPizza
//
//  Created by Константин Клинов on 25/07/25.
//

import SwiftUI

enum BannerType {
    case success
    case error

    var icon: String {
        switch self {
        case .success: return "ic_success"
        case .error: return "ic_error"
        }
    }

    var textColor: Color {
        switch self {
        case .success: return Color(Constants.Colors.successColor)
        case .error: return Color(Constants.Colors.mainColor)
        }
    }
}

struct BannerView: View {
    let message: String
    let type: BannerType
    @Binding var show: Bool

    var body: some View {
        if show {
            HStack {
                Spacer()

                Text(message)
                    .foregroundColor(type.textColor)
                    .font(.custom(Constants.Font.defaultFontRegular, size: 14))
                    .multilineTextAlignment(.center)

                Spacer()

                Image(type.icon)
            }
            .padding()
            .background(
                VisualEffectBlur(blurStyle: .systemMaterial)
                    .background(Color.white)
            )
            .cornerRadius(10)
            .shadow(color: Color.black.opacity(0.12), radius: 4, x: 0, y: 4)
            .padding(.horizontal, 16)
            .padding(.top, 0)
            .transition(.move(edge: .top).combined(with: .opacity))
            .animation(.spring(), value: show)
        }
    }
}
