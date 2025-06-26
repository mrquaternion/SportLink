//
//  Message.swift
//  SportLink
//
//  Created by Mathias La Rochelle on 2025-06-14.
//

import Foundation

struct Message: Identifiable {
    var id = UUID().uuidString
    let auteurId : UUID
    let contenu : String
    let timestamp : Date
}
