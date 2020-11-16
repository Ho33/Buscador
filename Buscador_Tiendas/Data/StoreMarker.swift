//
//  StoreMarker.swift
//  Buscador_Tiendas
//
//  Created by hh3 on 10/21/20.
//

import SwiftUI
import MapKit

class StoreMarker : Identifiable {
    
    var id = UUID()
    
    var name : String = ""
    var latitude: Double?
    var longitude : Double?
    var mallType : String = ""
    var distance: Int?
    var postalCode: String?
    var address: String?
    var timetable: String?
    var festiveTimetable: String?
    var wifiActive: Bool?
    var carrefourPayActive: Bool?
    var storeServices: [String]?
    
    var city: String?
    var groupTotalFuelstations: Int?
    var groupTotalMalls: Int?
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: self.latitude!, longitude: self.longitude!)
    }
    init (){}
    
    init(city: String, latitude: Double, longitude: Double, groupTotalFuelstations: Int, groupTotalMalls: Int) {
        self.city = city
        self.groupTotalFuelstations = groupTotalFuelstations
        self.groupTotalMalls = groupTotalMalls
        self.latitude = latitude
        self.longitude = longitude
    }
    
    init(name: String, latitude: Double, longitude: Double, mallType: String ,city: String, distance: Int, postalCode: String, address: String , timetable : String, festiveTimetable : String, wifiActive : Bool, carrefourPayActive: Bool, storeServices: [String]) {
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
        self.mallType = mallType
        self.distance = distance
        self.postalCode = postalCode
        self.address = address
        self.city = city
        self.timetable = timetable
        self.festiveTimetable = festiveTimetable
        self.wifiActive = wifiActive
        self.carrefourPayActive = carrefourPayActive
        self.storeServices = storeServices
    }
}
