//
//  StoreDetailsView.swift
//  Buscador_Tiendas
//
//  Created by hh3 on 11/16/20.
//

import SwiftUI
import MapKit

struct StoreDetailsView: View {
    var store : StoreMarker
    private let normalFontSize : CGFloat = 14
    private let capitalFontSize : CGFloat = 11
    @State private var localizedStore : [StoreMarker] = []
    @State private var location : MKCoordinateRegion = MKCoordinateRegion.init()
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView (showsIndicators: false, content: {
                VStack {
                    StoreRowView(item: store, rowSelected: true)
                    buttonDirectionToGo(geometry: geometry)
                    VStack {
                        direction.padding(.bottom,-9)
                        mapStoreSelected.allowsHitTesting(false)
                        schedouleInfo
                            .padding(.top,-10)
                        Divider().padding(EdgeInsets(top: -10, leading: 17, bottom: 25, trailing: 17))
                        HStack{
                            availableWifi
                                .padding(.leading,25)
                            Spacer()
                            price
                            Spacer()
                        }
                        Divider().padding(EdgeInsets(top: 5, leading: 17, bottom: 5, trailing: 17))
                        carrefourPayStatus
                            .padding(.leading,22)
                        Divider().padding(EdgeInsets(top: -5, leading: 17, bottom: 10, trailing: 17))
                        storeServices
                        Divider().padding(EdgeInsets(top: -10, leading: 17, bottom: 30, trailing: 17))
                    }
                    .border(Color.gray, width: 0.4)
                    .padding(EdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8))
                }
            })
            .onAppear {
                self.location = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude:store.latitude!, longitude: store.longitude!), span: MKCoordinateSpan(latitudeDelta: 0.07, longitudeDelta: 0.07))
                self.localizedStore.append(store)
            }
        }.navigationBarTitle(Text("Tienda"), displayMode: .inline)
        .edgesIgnoringSafeArea(.bottom)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading:
                                Button(action: {
                                    self.presentationMode.wrappedValue.dismiss()
                                }) {
                                    HStack {
                                        Image(systemName: "control").rotationEffect(Angle(degrees: -90))
                                            .foregroundColor(.white)
                                    }.frame(width: 30, height: 30, alignment: .center)
                                })
    }
    
    private var direction : some View {
        HStack{
            VStack{
                Group{
                    HStack{
                        Text("DIRECCIÓN").foregroundColor(.gray)
                        Spacer()
                    }.font(.system(size: capitalFontSize))
                    .padding(.bottom,1)
                    Group{
                        HStack{
                            Text(store.address!)
                            Spacer()
                        }
                        HStack{
                            Text(store.postalCode!)
                            Text(store.city!)
                            Spacer()
                        }
                    }.foregroundColor(.blue)
                    .font(.system(size: normalFontSize))
                }
                
            }
            .padding()
            Spacer()
        }
    }
    
    private var mapStoreSelected : some View {
        VStack{
            Map(coordinateRegion: $location, interactionModes: .all , showsUserLocation: false, userTrackingMode: .none, annotationItems: localizedStore ) { item in
                MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: store.latitude!, longitude: store.longitude!)){
                    Image(getIconForBuscadorMapa(mallType: store.mallType))
                        .resizable()
                        .scaledToFit()
                }
            }
        }.frame(height: 200)
    }
    
    private var schedouleInfo : some View {
        HStack{
            VStack{
                Group{
                    HStack {
                        Text("HORARIO COMERCIAL").foregroundColor(.gray)
                        Spacer()
                    }.font(.system(size: capitalFontSize))
                    Group{
                        HStack {
                            Text("Laborales: " + store.timetable!).fixedSize(horizontal: false, vertical: true)
                            Spacer()
                        }
                        
                        HStack {
                            Text("Festivos: " + store.festiveTimetable!).fixedSize(horizontal: false, vertical: true)
                            Spacer()
                        }
                    }.font(.system(size: normalFontSize))
                }.padding(.bottom,1)
            }.padding()
            Spacer()
        }
    }
    
    private func buttonDirectionToGo (geometry : GeometryProxy) -> some View {
        Button(action: {
                let url = URL(string: "http://maps.apple.com/maps?saddr=&daddr=\(store.latitude ?? 0),\(store.longitude ?? 0)")
                UIApplication.shared.open(url!)}, label: {
                    Text("Cómo llegar")
                        .frame(width: geometry.size.width/1.04, height: geometry.size.height/16)
                        .background(
                            RoundedRectangle(cornerRadius: 2)
                                .stroke(lineWidth: 2)
                        )
                })
    }
    
    private var availableWifi : some View {
        HStack{
            Image(systemName: "dot.radiowaves.right")
                .foregroundColor(Color.white)
                .rotationEffect(Angle(degrees: -90))
                .background(Circle()
                                .fill(store.wifiActive! ? Color.blue : Color.gray.opacity(0.3))
                                .frame(width: 30, height: 30))
            Text("Wifi")
                .font(.system(size: normalFontSize))
                .padding(.leading,5)
        }.padding(EdgeInsets(top: -10, leading: 0, bottom: 10, trailing: 0))
    }
    
    private var price : some View {
        HStack{
            Image(systemName: "qrcode.viewfinder")
                .foregroundColor(Color.white)
                .background(Circle()
                                .fill(Color.blue)
                                .frame(width: 30, height: 30))
            Text("Ver precio")
                .font(.system(size: normalFontSize))
                .padding(.leading,5)
        }.padding(EdgeInsets(top: -10, leading: 0, bottom: 10, trailing: 0))
    }
    
    private var carrefourPayStatus : some View {
        HStack{
            Text(self.store.carrefourPayActive! ? "Carrefour Pay disponible" : "Carrefour Pay no disponible")
            Spacer()
        }.font(.system(size: normalFontSize))
        .padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))
    }
    
    private var storeServices : some View {
        VStack{
            Group{
                HStack{
                    Text("OTROS SERVICIOS").foregroundColor(.gray)
                    Spacer()
                }
                .font(.system(size: capitalFontSize))
                VStack{
                    ForEach(self.store.storeServices! , id: \.self) { service in
                        HStack{
                            Text("\(service)")
                            Spacer()
                        }
                        .font(.system(size: normalFontSize))
                    }
                }
            }.padding(.bottom,1)
            Spacer()
        }
        .padding(EdgeInsets(top:0, leading: 17, bottom: 10, trailing: 0))
    }
}


struct StoreDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        
        Group {
            StoreDetailsView(store: StoreMarker(name: "Carrefour test", latitude: 0, longitude: 0, mallType: "asd", city: "Madrid", distance: 0, postalCode: "06200", address: "C/pedro", timetable: "123", festiveTimetable: "321", wifiActive: true, carrefourPayActive: true, storeServices: ["Entrega","salida"])).previewDevice(PreviewDevice(rawValue: "iPhone XS Max"))
                .previewDisplayName("iPhone XS Max")
            
            StoreDetailsView(store: StoreMarker(name: "Carrefour test", latitude: 0, longitude: 0, mallType: "asd", city: "Madrid", distance: 0, postalCode: "06200", address: "C/pedro", timetable: "123", festiveTimetable: "321", wifiActive: true, carrefourPayActive: true, storeServices: ["Entrega","salida"])).previewDevice(PreviewDevice(rawValue: "iPhone 7"))
                .previewDisplayName("iPhone 7")
        }
    }
}

