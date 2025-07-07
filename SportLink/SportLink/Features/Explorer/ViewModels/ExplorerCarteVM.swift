//
//  CarteVueModele.swift
//  SportLink
//
//  Created by Mathias La Rochelle on 2025-06-21.
//

import Foundation
import MapKit

private let METERS_PER_DEGREE: Double = 111_320

func conversionLocalXY(point: CLLocationCoordinate2D, ref: CLLocationCoordinate2D) -> (x: Double, y: Double) {
    let cosLatRef = cos(ref.latitude * Double.pi / 180)
    let x = (point.longitude - ref.longitude) * cosLatRef * METERS_PER_DEGREE
    let y = (point.latitude - ref.latitude) * METERS_PER_DEGREE
    return (x, y)
}

func entreLimites(for point: CLLocationCoordinate2D, in poly: [CLLocationCoordinate2D]) -> Bool { // source : https://stackoverflow.com/questions/29344791/check-whether-a-point-is-inside-of-a-simple-polygon
    if poly.count <= 1 {
        return false
    }
    
    let ref = poly[0]
    let cgPoints: [CGPoint] = poly.compactMap { coord in
        let (x, y) = conversionLocalXY(point: coord, ref: ref)
        return CGPointMake(x, y)
    }
    
    var p = UIBezierPath()
    let premPoint = cgPoints[0] as CGPoint
    
    p.move(to: premPoint)
    
    for i in 1...(poly.count-1) {
        p.addLine(to: cgPoints[i] as CGPoint)
    }
    
    p.close()
    
    let pointXY = conversionLocalXY(point: point, ref: ref)
    
    return p.contains(CGPointMake(pointXY.x, pointXY.y))
}

func centrePolygone(for arr: [CLLocationCoordinate2D]) -> CLLocationCoordinate2D {
    guard let firstCoord = arr.first, arr.count > 2 else {
        return arr.first ?? CLLocationCoordinate2D()
    }
    
    let ref = arr[0]
    let cosLatRef = cos(ref.latitude * Double.pi / 180)

    let pointsXY = arr.map { coord -> (x: Double, y: Double) in
        return conversionLocalXY(point: coord, ref: ref)
    }

    var area = 0.0
    for i in 0..<pointsXY.count {
        let j = (i + 1) % pointsXY.count
        area += pointsXY[i].x * pointsXY[j].y - pointsXY[j].x * pointsXY[i].y
    }
    area *= 0.5

    var cx = 0.0
    var cy = 0.0
    for i in 0..<pointsXY.count {
        let j = (i + 1) % pointsXY.count
        let cross = pointsXY[i].x * pointsXY[j].y - pointsXY[j].x * pointsXY[i].y
        cx += (pointsXY[i].x + pointsXY[j].x) * cross
        cy += (pointsXY[i].y + pointsXY[j].y) * cross
    }
    cx /= (6 * area)
    cy /= (6 * area)

    let centroidLat = cy / METERS_PER_DEGREE + ref.latitude
    let centroidLon = cx / (cosLatRef * METERS_PER_DEGREE) + ref.longitude

    return CLLocationCoordinate2D(latitude: centroidLat, longitude: centroidLon)
}

func regionEnglobantPolygone(_ coords: [CLLocationCoordinate2D]) -> MKCoordinateRegion {
    guard !coords.isEmpty else {
        return MKCoordinateRegion()
    }
    
    var minLat = coords[0].latitude
    var maxLat = coords[0].latitude
    var minLon = coords[0].longitude
    var maxLon = coords[0].longitude
    
    for coord in coords {
        minLat = min(coord.latitude, minLat)
        maxLat = max(coord.latitude, maxLat)
        minLon = min(coord.longitude, minLon)
        maxLon = max(coord.longitude, maxLon)
    }
    
    let center = CLLocationCoordinate2D(
        latitude: (minLat + maxLat) / 2,
        longitude: (minLon + maxLon) / 2
    )
    
    let span = MKCoordinateSpan(
        latitudeDelta: (maxLat - minLat) * 1.2,
        longitudeDelta: (maxLon - minLon) * 1.2
    )
    
    return MKCoordinateRegion(center: center, span: span)
}
