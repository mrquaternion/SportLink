//
//  RectangleVue.swift
//  SportLink
//
//  Created by Michel Lamothe on 2025-07-02.
//

import SwiftUI

struct BoiteAvecChevron<Content: View>: View {
    let content: Content
    var cornerRadius: CGFloat = 12
    var fillColor: Color = .white
    var borderColor: Color = Color.gray.opacity(0.3)
    var showChevron: Bool = false

    init(
        cornerRadius: CGFloat = 12,
        fillColor: Color = .white,
        borderColor: Color = Color.gray.opacity(0.3),
        showChevron: Bool = false,
        @ViewBuilder content: () -> Content
    ) {
        self.cornerRadius = cornerRadius
        self.fillColor = fillColor
        self.borderColor = borderColor
        self.showChevron = showChevron
        self.content = content()
    }

    var body: some View {
        HStack {
            content
            Spacer()
            if showChevron {
                Image(systemName: "chevron.down")
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, minHeight: 50)
        .background(
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(fillColor)
                .overlay(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(borderColor, lineWidth: 1)
                )
                .shadow(color: Color.gray.opacity(0.1), radius: 2, x: 0, y: 1)
        )
        .padding(.horizontal)
    }
}

