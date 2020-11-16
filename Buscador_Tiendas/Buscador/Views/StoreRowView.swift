//
//  TEST.swift
//  Buscador_Tiendas
//
//  Created by hh3 on 11/6/20.
//

import SwiftUI

struct StoreRowView: View {
    var item : StoreMarker
    var rowSelected : Bool = false
    
    var body: some View {
        NavigationLink(destination: StoreDetailsView(store : self.item)) {
            HStack{
                Image(getIconForInStoreLocalized(mallType: self.item.mallType))
                    .frame(width: 60, height: 20, alignment: .center)
                    .padding(.top,40)
                VStack{
                    HStack{
                        Text(self.item.name)
                        Spacer()
                    }
                    HStack{
                        Text(self.item.address!).font(.system(size: 12))
                        Spacer()
                    }
                    HStack{
                        Text(self.item.postalCode!).font(.system(size: 12))
                        Text(self.item.city!).font(.system(size: 12))
                        Spacer()
                    }
                }.padding(.leading,-8)
                Spacer()
                VStack{
                ZStack{
                    Text("\(self.item.distance!)").font(.system(size: 12)).padding(.top,9)
                }.frame(width: 40, height: 20, alignment: .center)
                ZStack {
                    Image(systemName: "star.square").resizable().opacity(0.3)
                }.frame(width: 25, height: 25, alignment: .top)
                .padding(.bottom,5)
                }.padding()
            }.frame(width: self.rowSelected ? 380 : 355, height: 60, alignment: .center)
            .padding(EdgeInsets(top: self.rowSelected ? 8 : 0, leading: 0, bottom: self.rowSelected ? 8 : 0, trailing: 0))
            .border(Color.gray ,width: 0.3)
            
        }.buttonStyle(PlainButtonStyle())
    }
}


struct StoreRowView_Previews: PreviewProvider {
    static var previews: some View {
        StoreRowView(item: StoreMarker(name: "Carrefour test", latitude: 0, longitude: 0, mallType: "asd", city: "Madrid", distance: 0, postalCode: "06200", address: "C/pedro", timetable: "123", festiveTimetable: "321", wifiActive: true, carrefourPayActive: true, storeServices: ["Entrega","salida"]), rowSelected: true)
    }
}
