//
//  BuscadorBaseView.swift
//  Buscador_Tiendas
//
//  Created by usuario on 20/10/2020.
//

import SwiftUI
import MapKit
import Combine



class Region{
    var latitude: Double = 0
    var longitude: Double = 0
    var regionPoints: [String:CLLocationCoordinate2D] = [:]
    var limits: Int = 0
    
    init(){}
    init(latitude: Double,
         longitude: Double,
         regionPoints: [String:CLLocationCoordinate2D],
         limits: Int){
        self.latitude = latitude
        self.longitude = longitude
        self.regionPoints = regionPoints
        self.limits = limits
    }
}


struct BuscadorBaseView: View {
    
    @StateObject var managerDelegate = LocationManager()
    
    @ObservedObject var viewModel: BuscadorBaseViewModel = BuscadorBaseViewModel()
    
    @State private var storeMarker : [StoreMarker] = []
    @State private var search : String = ""
    @State var tracking : MapUserTrackingMode = .follow
    @State var coordinateRegion : MKCoordinateRegion = MKCoordinateRegion.init()
    @State var tempStores : [Store] = []
    @State var regionActual : MKCoordinateRegion?
    var body: some View {
        ZStack{
            TextField("Introduce Codigo Postal o Localidad", text : self.$search, onEditingChanged : {
                        _ in })
            {
                
            }
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding()
        }
        VStack {
            Map(coordinateRegion: $coordinateRegion, interactionModes: .all, showsUserLocation: true, userTrackingMode: $tracking,
                annotationItems: storeMarker) { place in
                MapAnnotation(coordinate: place.coordinate){
                    Image(getIconForBuscadorMapa(mallType: place.mallType))
                        .resizable()
                        .scaledToFit()
                }
            }
        }
        
        
        .onReceive(self.viewModel.$tiendas){ value in
            if self.tempStores != value {
                if let tiendasParaMostrar = value{
                    self.tempStores = tiendasParaMostrar
                    var nuevasTiendas: [StoreMarker] = []
                    for item in tiendasParaMostrar {
                        print(item.mallType!)
                        nuevasTiendas
                            .append(StoreMarker(name: item.name!, latitude: item.latitude!, longitude: item.longitude!, mallType: item.mallType!))
                    }
                    self.storeMarker = nuevasTiendas
                    print("\(tiendasParaMostrar.count)")
                }
            }
        }
        .onReceive(self.managerDelegate.$location) { value in
            if value != nil {
                self.coordinateRegion = getCoordinateRegion(location: value)
            }
        }
        .onReceive([self.$coordinateRegion].publisher.first()){ value in
            
            if self.regionActual?.center.latitude != value.center.latitude.wrappedValue && self.regionActual?.span.latitudeDelta != value.span.latitudeDelta.wrappedValue{
                
                self.regionActual = value.wrappedValue
                
                let centerLat: Double = value.center.latitude.wrappedValue
                
                let centerLng: Double = value.center.longitude.wrappedValue
                
                let spanLat: Double = value.span.latitudeDelta.wrappedValue
                
                let spanLng: Double = value.span.longitudeDelta.wrappedValue
                
                if centerLat != 0.0 && centerLng != 0.0{
                    
                    self.viewModel.getAllMalls(
                        centerCoordinates: CLLocation(latitude: centerLat, longitude: centerLng),region: Region(latitude: centerLat, longitude: centerLng, regionPoints: getFourBoundsMap(centerLat: centerLat, centerLng: centerLng, spanLat: spanLat, spanLng: spanLng) , limits: 500
                        ))
                    print("NEW REGION: \(value)")
                    
                    print("NW: \(centerLat - (spanLat/2)), \(centerLng + (spanLng/2))")
                    
                }
            }
        }
    }
    
    func getCoordinateRegion(location: CLLocation?) -> MKCoordinateRegion {
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: location?.coordinate.latitude ?? 40.41317, longitude: location?.coordinate.longitude ?? -3.68307), span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1))
        return region
    }
    func getFourBoundsMap(centerLat : Double, centerLng: Double, spanLat: Double,  spanLng: Double) -> [String:CLLocationCoordinate2D]{
        let NWCoord = CLLocationCoordinate2D(latitude: centerLat + spanLat/2, longitude: centerLng - (spanLng/2))
        let SECoord = CLLocationCoordinate2D(latitude: centerLat - spanLat/2, longitude: centerLng + (spanLng/2))
        return ["NWCoord": NWCoord, "SECoord": SECoord]
    }
}

struct BuscadorBaseView_Previews: PreviewProvider {
    static var previews: some View {
        BuscadorBaseView()
    }
}

