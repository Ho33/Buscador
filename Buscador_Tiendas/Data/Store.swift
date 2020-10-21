//
//  Store.swift
//  Buscador_Tiendas
//
//  Created by usuario on 20/10/2020.
//

import SwiftUI

struct Store: Codable, Hashable {
    
    var address: String?
    var atica: String?
    var carrefourServices: [String]?
    var city: String?
    var community: String?
    var distance: Int?
    var facebook: String?
    var timetable: String?
    var festiveTimetable: String?
    var instagram: String?
    var latitude: Double?
    var longitude: Double?
    var mallId: String?
    var mallType: String?
    var name: String?
    var phone: String?
    var postalCode: String?
    var province: String?
    var sapCode: String?
    var storeServices: [String]?
    var carrefourPayActive: Bool?
    var wifiActive: Bool?
    var turnomaticActive: Bool?
    var totalPumps: Int?
    
}

struct Malls: Codable{
    var _embedded: mallsEmbedded?
}

struct mallsEmbedded: Codable{
    var mallResources: [Store]?
}

struct MallsByCity: Codable{
    var mallGroupList: [GroupedMalls]?
}

struct GroupedMalls: Codable{
    var latitude: Double?
    var longitude: Double?
    var city: String?
    var totalFuelstations: Int?
    var totalMalls: Int?
}

func getIconForFavouriteStore(mallType: String) -> String {
    switch mallType {
        case "HYPERMARKET":
            return "icon_no_geo_hiper"
        case "SUPERMARKET_CARREFOUR_MARKET":
            return "icon_no_geo_market"
        case "SUPERMARKET_CARREFOUR_EXPRESS":
            return "icon_no_geo_express"
        case "SUPERMARKET_CARREFOUR_EXPRESS_CEPSA":
            return "icon_no_geo_cepsa"
        case "SUPERMARKET_CARREFOUR_BIO":
            return "icon_no_geo_bio"
        case "FUEL_STATION":
            return "icon_no_geo_gaso"
        default:
            return "icon_no_geo_hiper"
    }
}

func getIconForInStoreLocalized(mallType: String) -> String {
    switch mallType {
        case "HYPERMARKET":
            return "icon_geo_hiper"
        case "SUPERMARKET_CARREFOUR_MARKET":
            return "icon_geo_market"
        case "SUPERMARKET_CARREFOUR_EXPRESS":
            return "icon_geo_express"
        case "SUPERMARKET_CARREFOUR_EXPRESS_CEPSA":
            return "icon_geo_cepsa"
        case "SUPERMARKET_CARREFOUR_BIO":
            return "icon_geo_bio"
        case "FUEL_STATION":
            return "icon_geo_gaso"
        default:
            return "icon_geo_hiper"
    }
}

func getIconForClosestStore(mallType: String) -> String {
    switch mallType {
        case "HYPERMARKET":
            return "geo_out_hiper"
        case "SUPERMARKET_CARREFOUR_MARKET":
            return "geo_out_market"
        case "SUPERMARKET_CARREFOUR_EXPRESS":
            return "geo_out_express"
        case "SUPERMARKET_CARREFOUR_EXPRESS_CEPSA":
            return "geo_out_cepsa"
        case "SUPERMARKET_CARREFOUR_BIO":
            return "geo_out_bio"
        case "FUEL_STATION":
            return "icon-nearest-fuel-station"
        default:
            return "geo_out_hiper"
    }
}

func getIconForGeneralStore(mallType: String) -> String {
    switch mallType {
        case "HYPERMARKET":
            return "icon-corporative"
        case "SUPERMARKET_CARREFOUR_MARKET":
            return "icon-market"
        case "SUPERMARKET_CARREFOUR_EXPRESS":
            return "icon-express"
        case "SUPERMARKET_CARREFOUR_EXPRESS_CEPSA":
            return "icon-cepsa"
        case "SUPERMARKET_CARREFOUR_BIO":
            return "icon-bio"
        case "FUEL_STATION":
            return "icon-fuel-station"
        case "TRAVEL_AGENCY":
            return "icon-travel"
        default:
            return "icon-corporative"
    }
}

func getIconForBuscadorMapa(mallType: String) -> String {
    switch mallType {
        case "HYPERMARKET":
            return "icon-annotation-corporative"
        case "SUPERMARKET_CARREFOUR_MARKET":
            return "icon-annotation-market"
        case "SUPERMARKET_CARREFOUR_EXPRESS":
            return "icon-annotation-express"
        case "SUPERMARKET_CARREFOUR_EXPRESS_CEPSA":
            return "icon-annotation-cepsa"
        case "SUPERMARKET_CARREFOUR_BIO":
            return "icon-annotation-bio"
        case "FUEL_STATION":
            return "icon-annotation-fuelStation"
        case "TRAVEL_AGENCY":
            return "icon-annotation-travel"
        default:
            return "icon-annotation-corporative"
    }
}
