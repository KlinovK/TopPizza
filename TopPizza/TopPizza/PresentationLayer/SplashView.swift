//
//  SplashView.swift
//  TopPizza
//
//  Created by Константин Клинов on 24/07/25.
//

import SwiftUI

struct SplashView: View {
    
    @State private var isActive = false
    
    var body: some View {
        Group {
            if isActive {
                AuthView()
            } else {
                ZStack {
                    Color(Constants.Colors.mainColor)
                        .ignoresSafeArea()
                    Image("ic_logo_white")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 322, height: 103)
                }
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        isActive = true
                    }
                }
            }
        }
    }
}

#Preview {
    SplashView()
}
