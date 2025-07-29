//
//  String.swift
//  SportLink
//
//  Created by Mathias La Rochelle on 2025-07-25.
//

import Foundation

extension String {
    var localizedFirstCapitalized: String {
        return NSLocalizedString(self, comment: "").localizedFirstCapitalizedProtocol
    }
}

extension StringProtocol {
    var localizedFirstCapitalizedProtocol: String {
        prefix(1).capitalized(with: .current) + dropFirst()
    }
}
