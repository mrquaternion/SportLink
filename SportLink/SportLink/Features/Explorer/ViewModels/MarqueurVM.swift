//
//  MarqueurVueModele.swift
//  SportLink
//
//  Created by Mathias La Rochelle on 2025-06-24.
//

import Foundation
import SwiftUI

func imagePourSports(_ sports: [Sport]) -> UIImage? {
    if sports.count == 1 { // si 1 sport, on retourn l'image
        return UIImage(systemName: sports[0].icone)
    } else { // si 2 ou plus mais il n'y a jamais plus que 2
        let images = sports.compactMap { UIImage(systemName: $0.icone) }

        let size = CGSize(width: 55, height: 55)
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)

        for (index, image) in images.enumerated() {
            let offset = CGFloat(index * 24) // décale légèrement
            image.draw(in: CGRect(x: offset, y: offset, width: 34, height: 34)) // à la diagonale
        }

        let combinees = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return combinees
    }
}
