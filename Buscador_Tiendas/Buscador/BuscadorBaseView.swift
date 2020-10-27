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
    var regionPoints: [String:CLLocationDegrees] = [:]
    var limits: Int = 0
    
    init(){}
    init(latitude: Double,
         longitude: Double,
         regionPoints: [String:CLLocationDegrees],
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
            Map(coordinateRegion: $coordinateRegion, interactionModes: .all, showsUserLocation: true, /*userTrackingMode: $tracking ,*/
                annotationItems: storeMarker) { place in
                MapAnnotation(coordinate: place.coordinate){
                    Image(getIconForBuscadorMapa(mallType: place.mallType))
                        .resizable()
                        .scaledToFit()
                }
            }
        }
        
        .onReceive([self.coordinateRegion].publisher.first()){ value in
            self.viewModel.getAllMalls(centerCoordinates: CLLocation(latitude: value.center.latitude, longitude: value.center.longitude))
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
                self.viewModel.getAllMalls(
                    centerCoordinates: CLLocation(latitude: value!.coordinate.latitude, longitude: value!.coordinate.longitude))
            }
        }
    }

    func getCoordinateRegion(location: CLLocation?) -> MKCoordinateRegion {
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: location?.coordinate.latitude ?? 40.41317, longitude: location?.coordinate.longitude ?? -3.68307), span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1))
        return region
    }
}

struct BuscadorBaseView_Previews: PreviewProvider {
    static var previews: some View {
        BuscadorBaseView()
    }
}

extension Array where Element == MKMapPoint {
    func mapRect() -> MKMapRect? {
        guard count > 0 else { return nil }

        let xs = map { $0.x }
        let ys = map { $0.y }

        let west = xs.min()!
        let east = xs.max()!
        let width = east - west

        let south = ys.min()!
        let north = ys.max()!
        let height = north - south

        return MKMapRect(x: west, y: south, width: width, height: height)
    }
}
