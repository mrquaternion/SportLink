//
//  ChargeurJSON.swift
//  SportLink
//
//  Created by Mathias La Rochelle on 2025-06-15.
//

import Foundation

class ChargeurJSON {
    static func chargementCollection(from nomFichier: String) throws -> Collection {
        let url = Bundle.main.url(forResource: nomFichier, withExtension: "json")!;
        let data = try Data(contentsOf: url)
        return try JSONDecoder().decode(Collection.self, from: data)
    }
}
