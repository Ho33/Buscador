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
    
    @State private var tempStores : [Store] = []
    @State private var storeMarker : [StoreMarker] = []
    @State private var tempGroupedMalls : [GroupedMalls] = []
    @State private var groupMarker : [StoreMarker] = []
    @State private var annotationsToShow : [StoreMarker] = []
    @State private var search : String = ""
    @State private var tracking : MapUserTrackingMode = .follow
    @State private var coordinateRegion : MKCoordinateRegion = MKCoordinateRegion.init()
    @State private var regionActual : MKCoordinateRegion?
    @State private var showStoreList: Bool = false

    
    var body: some View {
        
        NavigationView {
            VStack{
                VStack{
                    HStack{
                        Group{
                            Button(action: {
                                self.showStoreList = false
                            }, label: {
                                Text("MAPA").foregroundColor(self.showStoreList ? .gray : .blue)
                            })
                            
                            Button(action: {
                                self.showStoreList = true
                            }, label: {
                                Text("LISTADO").foregroundColor(self.showStoreList ? .blue : .gray)
                                
                            })
                            
                        }.font(.system(size: 15))
                        .foregroundColor(.gray)
                        .frame(width: 180, height: 40, alignment: .center)
                    }.padding(EdgeInsets(top: 5, leading: 0, bottom: -5, trailing: 0))
                    
                    HStack{
                        Rectangle().frame(width: 180, height: 3)
                            .foregroundColor(Color.blue)
                            .offset(x: self.showStoreList ? 88 : -88, y: -7).animation(.spring())
                    }
                }
                VStack{
                    HStack{
                        Image(systemName: "magnifyingglass")
                            .padding(.leading,5)
                        
                        TextField("Introduce Código Postal o Localidad", text : self.$search, onEditingChanged : {
                                    _ in })
                        {
                            
                        }
                    }.padding(EdgeInsets(top: 8, leading: 5, bottom: 8, trailing: 5))
                    .overlay(RoundedRectangle(cornerRadius: 2).stroke(Color.gray, lineWidth: 0.5))
                    .padding(EdgeInsets(top: 10, leading: 5, bottom: 0, trailing: 5))
                    HStack{
                        Text("Puedes cambiar tu tienda favorita desde el listado o accediendo a su información detallada.").foregroundColor(.gray).font(.system(size: 13))
                    }
                    .padding(EdgeInsets(top: 10, leading: 5, bottom: 0, trailing: 30))
                    HStack{
                        Spacer()
                        Button(action: {
                           //vista para filtrar
                        }, label: {
                            Image(systemName: "slider.horizontal.3").font(.system(size: 13))
                            Text("Filtrar").font(.system(size: 13))
                        })
                    }.padding(EdgeInsets(top: 3, leading: 0, bottom: 0, trailing: 18))
                    HStack{
                        if !self.showStoreList {
                            Map(coordinateRegion: $coordinateRegion, interactionModes: .all, showsUserLocation: true, userTrackingMode: $tracking,
                                annotationItems: annotationsToShow ) { place in
                                MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: place.latitude!, longitude: place.longitude!)){
                                    if place.mallType != "" {
                                        Image(getIconForBuscadorMapa(mallType: place.mallType))
                                            .resizable()
                                            .scaledToFit()
                                        
                                    } else {
                                        Image("icon-annotation-grouped")
                                            .resizable()
                                            .scaledToFit()
                                    }
                                }
                            }
                        }
                    }.padding(.bottom, self.showStoreList ? 10:0)
                }.overlay(
                    RoundedRectangle(cornerRadius: 3).stroke(Color(.gray), lineWidth: 0.3)
                )
                .padding(EdgeInsets(top: -17, leading: 5, bottom: 0, trailing: 5))
                .padding(EdgeInsets(top: 3, leading: 5, bottom: -15, trailing: 5))
                
                Spacer()
                Group{
                    if self.showStoreList {
                        
                        ScrollView (.vertical, showsIndicators: false, content: {
                            ForEach(self.annotationsToShow) { store in
                                if store.name != "" {
                                    StoreRowView(item: store).padding(.bottom,-8)
                                }
                             }
                        }).padding(EdgeInsets(top: 9, leading: 10, bottom: 0, trailing: 10))
                        
                    }
                    
                }
            }
            .navigationBarTitle("Buscar tiendas", displayMode: .inline)
            .background(NavigationConfigurator { nc in
                nc.navigationBar.barTintColor = .blue
                nc.navigationBar.titleTextAttributes = [.foregroundColor : UIColor.white]
            })
        }
        .onReceive([self.$coordinateRegion].publisher.first()){ value in
            
            if self.regionActual?.center.latitude != value.center.latitude.wrappedValue && self.regionActual?.span.latitudeDelta != value.span.latitudeDelta.wrappedValue{

                self.regionActual = value.wrappedValue

                let centerLat: Double = value.center.latitude.wrappedValue

                let centerLng: Double = value.center.longitude.wrappedValue

                let spanLat: Double = value.span.latitudeDelta.wrappedValue

                let spanLng: Double = value.span.longitudeDelta.wrappedValue

                print(self.regionActual!.span.latitudeDelta)

                        self.viewModel.getAllMalls(
                        centerCoordinates: CLLocation(latitude: centerLat, longitude: centerLng),region: Region(latitude: centerLat, longitude: centerLng, regionPoints: getFourBoundsMap(centerLat: centerLat, centerLng: centerLng, spanLat: spanLat, spanLng: spanLng) , limits: 500
                        ))
                    self.changePlacemarks()

//                    print("NEW REGION: \(value)")
//
//                    print("NW: \(centerLat - (spanLat/2)), \(centerLng + (spanLng/2))")

            }
        }
        .onReceive(self.managerDelegate.$location) { value in
            if value != nil {
                self.coordinateRegion = getCoordinateRegion(location: value)
            }
        }
        .onReceive(self.viewModel.$tiendas){ value in
            if self.tempStores != value {
                if let tiendasParaMostrar = value{
                    self.tempStores = tiendasParaMostrar
                    var nuevasTiendas: [StoreMarker] = []
                    for item in tiendasParaMostrar {
                        print(item.distance!)
                        nuevasTiendas
                            .append(StoreMarker(name: item.name!, latitude: item.latitude!, longitude: item.longitude!, mallType: item.mallType!,city: item.city! , distance: item.distance!, postalCode: item.postalCode!, address: item.address!))
                    }
                    self.storeMarker = nuevasTiendas
                    print("\(tiendasParaMostrar.count)")
                }
            }
            self.changePlacemarks()
        }
        .onReceive(self.viewModel.$grupos) { value in
            if self.tempGroupedMalls != value {
                if let groupedMalls = value{
                    self.tempGroupedMalls = groupedMalls
                    var newGroupedMalls: [StoreMarker] = []
                    for item in groupedMalls {
                        print(item.city!)
                        newGroupedMalls
                            .append(StoreMarker(city: item.city!, latitude: item.latitude!, longitude: item.longitude!, groupTotalFuelstations: item.totalFuelstations!, groupTotalMalls: item.totalMalls!))
                    }
                    self.groupMarker = newGroupedMalls
                    print("\(groupedMalls.count)","hola")
                }
            }
            self.annotationsToShow = self.groupMarker
        }
    }
    func removeRepeatAnnotation(){
        var storeTemp = StoreMarker.init()
        var storesTemp : [StoreMarker] = []
        for store in self.annotationsToShow {
            if storeTemp.address != store.address {
                storeTemp = store
                storesTemp.append(store)
            }
            self.annotationsToShow = storesTemp
        }
    }
    
    func changePlacemarks() -> Void {
        if self.regionActual?.span.latitudeDelta ?? 0 > 1.0 {
            self.viewModel.getGroupedMalls()
        }else{
            self.annotationsToShow = self.storeMarker
            self.removeRepeatAnnotation()
        }
    }
    
    func getCoordinateRegion(location: CLLocation?) -> MKCoordinateRegion {
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: location?.coordinate.latitude ?? 40.41317, longitude: location?.coordinate.longitude ?? -3.68307), span: MKCoordinateSpan(latitudeDelta: 0.3, longitudeDelta: 0.3))
        return region
    }
    
    func getFourBoundsMap(centerLat : Double, centerLng: Double, spanLat: Double,  spanLng: Double) -> [String:CLLocationCoordinate2D]{
        let NWCoord = CLLocationCoordinate2D(latitude: centerLat + spanLat/2, longitude: centerLng - (spanLng/2))
        let SECoord = CLLocationCoordinate2D(latitude: centerLat - spanLat/2, longitude: centerLng + (spanLng/2))
        return ["NWCoord": NWCoord, "SECoord": SECoord]
    }
    
    struct NavigationConfigurator: UIViewControllerRepresentable {
        var configure: (UINavigationController) -> Void = { _ in }

        func makeUIViewController(context: UIViewControllerRepresentableContext<NavigationConfigurator>) -> UIViewController {
            UIViewController()
        }
        func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<NavigationConfigurator>) {
            if let nc = uiViewController.navigationController {
                self.configure(nc)
            }
        }
    }
}

struct BuscadorBaseView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            BuscadorBaseView()
        }
    }
}

