//
//  UIApplication.swift
//  SportLink
//
//  Created by Mathias La Rochelle on 2025-07-12.
//

import Foundation
import SwiftUI

extension UIApplication {
    func terminerEditage() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
