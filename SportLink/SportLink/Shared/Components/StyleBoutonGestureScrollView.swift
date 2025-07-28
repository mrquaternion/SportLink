//
//  StyleBoutonGestureScrollView.swift
//  SportLink
//
//  Created by Mathias La Rochelle on 2025-07-25.
//

import Foundation
import SwiftUI

struct StyleBoutonGestureScrollView: ButtonStyle {
    // MARK: Variables
    private var tempsAppuiLong: TimeInterval
    private var actionAppui: () -> Void
    private var actionAppuiLong: () -> Void
    private var actionFin: () -> Void
    
    @State var dateAppuiLong = Date()
    
    init(
        actionAppui: @escaping () -> Void,
        tempsAppuiLong: TimeInterval,
        actionAppuiLong: @escaping () -> Void,
        actionFin: @escaping () -> Void
    ) {
        self.actionAppui = actionAppui
        self.tempsAppuiLong = tempsAppuiLong
        self.actionAppuiLong = actionAppuiLong
        self.actionFin = actionFin
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .onChange(of: configuration.isPressed) { _, estAppuyeeNvValeur in
                if estAppuyeeNvValeur {
                    actionAppui()
                } else {
                    actionFin()
                }
            }
    }
}

private extension StyleBoutonGestureScrollView {
   func essayerDeclencherAppuiLongApresDelai(declenche date: Date) {
       DispatchQueue.main.asyncAfter(deadline: .now() + tempsAppuiLong) {
           guard date == dateAppuiLong else { return }
           actionAppuiLong()
       }
   }
}
