//
//  BuscadorBaseViewModel.swift
//  Buscador_Tiendas
//
//  Created by usuario on 20/10/2020.
//

import Foundation
import Combine
import SwiftUI
import MapKit

class BuscadorBaseViewModel: ObservableObject{
    
    
    
    @Published var tiendas: [Store]?
    @Published var grupos: [GroupedMalls]?
    
    var cancelable: Cancellable?
    
    func generarLlamadaGetGroupedMalls() -> AnyPublisher<MallsByCity,Error> {
        var params: [String:String] = [:]
        
//        params["mallTypeList"] = FiltrosBuscador.getStringStoresFromFilters(array: FiltrosBuscador.getFilterSearchStore(filtrosAplicables: filtrosAplicables))
        
        return lanzarPeticionPublicador(url: UrlBase.mallsByCity,
            httpMethod: .get,
            isAnonymus: true,
            isC4ApiRequest: true,
            mustEncodeParams: false,
            params: params).eraseToAnyPublisher()
    }
    
    func generarLlamadaGetMalls(centerCoordinates: CLLocation,
                                            region: Region?) -> AnyPublisher<Malls, Error> {
        
        var params : [String:String] = [:]
        params["longitude"] = "\(centerCoordinates.coordinate.longitude)"
        params["latitude"] = "\(centerCoordinates.coordinate.latitude)"
        
        if let newRegion = region{
            params = [
                "quadrantFirstLatitude": "\(newRegion.regionPoints["NWCoord"] ?? 0.0)",
                "quadrantFirstLongitude": "\(newRegion.regionPoints["NWCoord"] ?? 0.0)",
                "quadrantSecondLatitude": "\(newRegion.regionPoints["SECoord"] ?? 0.0)",
                "quadrantSecondLongitude": "\(newRegion.regionPoints["SECoord"] ?? 0.0)"
            ]
            params["numTopNearest"] = "\(newRegion.limits)"
            params["size"] = "\(newRegion.limits)"
        }
        
//        if let busquedaTexto = texto{
//            params["numTopNearest"] = "500"
//            params["size"] = "500"
//            let num = Int(busquedaTexto)
//            if num != nil {
//                //search by postalCode
//                params["postalCode"] = busquedaTexto
//
//            } else {
//                //search by City
//                if busquedaTexto != "" {
//                    params["city"] = busquedaTexto
//                    params["cityByRegexp"] = "true"
//                }
//            }
//        }
        
        params["hideClosedMalls"] = "true"
        
//        params["mallTypeList"] = FiltrosBuscador.getStringStoresFromFilters(array: FiltrosBuscador.getFilterSearch(filtrosAplicables: filtrosAplicables))
        
        
        return lanzarPeticionPublicador(url: UrlBase.malls,
                                        httpMethod: .get,
                                        isAnonymus: true,
                                        isC4ApiRequest: true,
                                        mustEncodeParams: false,
                                        params: params).eraseToAnyPublisher()
    }
    
    
    
    
    func getAllMalls(centerCoordinates: CLLocation,
                     region: Region? = nil){
        cancelable = generarLlamadaGetMalls(centerCoordinates: centerCoordinates,
                                            region: region).sink(receiveCompletion: {   
                    switch $0{
                    case .failure(let err): print("Error obteniendo tiendas \(err)")
                    case .finished: ()
                    }
        }, receiveValue: { malls in
            if let embedded = malls._embedded{
                self.tiendas = embedded.mallResources ?? []
            } else {
                self.tiendas = []
            }
        })
    }
    
    func getGroupedMalls(){
        cancelable = generarLlamadaGetGroupedMalls().sink(receiveCompletion: {
            switch $0{
            case .failure(let err): print("Error obteniendo grupo de tiendas \(err)")
            case .finished: ()
            }
        }, receiveValue: { groupedMalls in
            self.grupos = groupedMalls.mallGroupList ?? []
        })
    }
    
    
}
