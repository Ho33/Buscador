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
        .onAppear {
           // self.viewModel.getAllMalls(
               // centerCoordinates: CLLocation(latitude: 40.41317, longitude: -3.68307))//Madrid
        }
        .onReceive(self.viewModel.$tiendas){ value in
            if let tiendasParaMostrar = value{
                self.storeMarker.removeAll()
                for item in tiendasParaMostrar {
                    print(item.mallType!)
                    self.storeMarker
                        .append(StoreMarker(name: item.name!, latitude: item.latitude!, longitude: item.longitude!, mallType: item.mallType!))
                }
                print("\(tiendasParaMostrar.count)")
            }
        }
        .onReceive(self.managerDelegate.$location) { value in
            print(self.coordinateRegion, "old location")
            if value != nil {
                self.coordinateRegion = getCoordinateRegion(location: value)
                self.viewModel.getAllMalls(
                    centerCoordinates: CLLocation(latitude: value!.coordinate.latitude, longitude: value!.coordinate.longitude))
                print(value?.coordinate ?? 0, "new location")
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
