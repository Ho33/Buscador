//
//  UrlProtocol.swift
//  Buscador_Tiendas
//
//  Created by usuario on 20/10/2020.
//

import Foundation


protocol UrlProtocol{
    func getUrl(isAnonymus: Bool) -> String?
}

/// Enumerado para obtener las urls de los PLIST de configuración
enum UrlBase: String, UrlProtocol{
    
    case loadHome = "loadHome"
    case geolocator = "geolocator"
    case fuelStation = "fuelStation"
    case jwtLogin = "jwtLogin"
    case urlDestacados = "urlDestacados"
    case urlPromociones = "urlPromociones"
    case loginGigya = "loginGigya"
    case loginWeb = "loginWeb"
    case profileClient = "profileClient"
    case userPolicies = "userPolicies"
    case ecommerceCategorias = "ecommerceCategorias"
    case lists = "lists"
    case gmidCookie = "gmidCookie"
    case orders = "orders"
    case cart = "cart"
    case productsByEan = "productsByEanUrl"
    case recoveryAccount = "urlRecoveryPersonalData"
    case personalData = "urlPersonalData"
    case favouriteMall = "favouriteMall"
    case malls = "mallUrl"
    case mallsByCity = "mallsByCity"
    case imaginery = "imaginery"
    case fidelization = "fidelization"
    case addCupon = "addCupon"
    case setPapelCero = "setPapelCero"
    case getTicketInfo = "getTicketInfo"
    case comunicaciones = "comunicaciones"
    case intereses = "intereses"
    case billingData = "billingData"
    case getRoadTypes = "getRoadTypes"
    case getProvincias = "getProvincias"
    case direccion = "direccion"
    case guardarAlias = "guardarAlias"
    case urlOgone = "urlOgone"
    case validateCreditCard = "validateCreditCard"
    case validateVerificationKey = "validateVerificationKey"
    case securityConfig = "securityConfig"
    case eliminarTarjeta = "eliminarTarjeta"
    case activarTarjeta = "activarTarjeta"
    case validacionTarjeta = "validacionTarjeta"
    case purchasesBase = "purchasesBase"
    case devoluciones = "devoluciones"
    case address = "address"
    case eliminarTarjetaCompartida = "eliminarTarjetaCompartida"
    
    func getUrl(isAnonymus: Bool) -> String? {
        let dictionaryName = isAnonymus ? "urlAnonymus" : "url"
        guard let urlDictionary = Bundle.main.object(forInfoDictionaryKey: dictionaryName) as? Dictionary<String,String> else { return nil }
        return urlDictionary[self.rawValue]
    }
}

/// Estructura para crear url a partir de una url base y unos parametros que pueden introducirse en cualquier parte de la url
struct UrlWithParameters: UrlProtocol {
    
    var url: UrlBase
    var params: [String]
    
    init(url: UrlBase, params: [String]) {
        self.url = url
        self.params = params
    }
    
    func getUrl(isAnonymus: Bool) -> String? {
        let concatUrl: String? = self.url.getUrl(isAnonymus: isAnonymus)
        return String(format: concatUrl ?? "", arguments: params)
    }
}

struct UrlCustom: UrlProtocol{
    var url: String
    
    init(url: String){
        self.url = url
    }
    
    func getUrl(isAnonymus: Bool) -> String? {
        return self.url
    }
}
