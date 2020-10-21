//
//  StoreMarker.swift
//  Buscador_Tiendas
//
//  Created by hh3 on 10/21/20.
//

import SwiftUI
import MapKit

struct StoreMarker: Identifiable {
    var id = UUID()
    
    let name : String
    let latitude: Double
    let longitude : Double
    let mallType : String
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
    }
}
