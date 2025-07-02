//
//  CustomOverlay.swift
//  SportLink
//
//  Created by Michel Lamothe on 2025-07-02.
//

import SwiftUI

struct CustomOverlay<Content: View>: View {
    @Binding var isPresented: Bool
    let content: Content

    init(isPresented: Binding<Bool>, @ViewBuilder content: () -> Content) {
        self._isPresented = isPresented
        self.content = content()
    }

    var body: some View {
        if isPresented {
            ZStack {
                // Arrière-plan sombre
                Color.black.opacity(0.5)
                    .ignoresSafeArea()
                    .onTapGesture {
                        isPresented = false // Fermer si on tape autour
                    }

                // Contenu centré
                VStack {
                    content
                }
                .padding()
                .background(Color.white)
                .cornerRadius(12)
                .shadow(radius: 8)
                .frame(maxWidth: 300, maxHeight: 400)
            }
            .transition(.opacity)
            .animation(.easeInOut, value: isPresented)
        }
    }
}
