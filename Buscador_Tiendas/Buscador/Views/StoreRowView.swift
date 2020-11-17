//
//  TEST.swift
//  Buscador_Tiendas
//
//  Created by hh3 on 11/6/20.
//

import SwiftUI

struct StoreRowView: View {
    var item : StoreMarker
    @State var rowSelected : Bool = false
    
    var body: some View {
        NavigationLink(destination: StoreDetailsView(store : self.item), isActive : $rowSelected) {
            HStack{
                Image(getIconForInStoreLocalized(mallType: self.item.mallType))
                    .frame(width: 60, height: 20, alignment: .center)
                    .padding(.top,40)
                VStack{
                    HStack{
                        Text(self.item.name)
                        Spacer()
                    }.padding(.trailing,20)
                    Group {
                        HStack{
                            Text(self.item.address!)
                            Spacer()
                        }
                        HStack{
                            Text(self.item.postalCode!)
                            Text(self.item.city!)
                            Spacer()
                        }
                    }.font(.system(size: 12))
                }.padding(.leading,-8)
                .lineLimit(1)
                
                Spacer()
                VStack{
                ZStack{
                    Text("\(self.item.distance!)").font(.system(size: 12)).padding(.top,9)
                }.frame(width: 40, height: 20, alignment: .center)
                ZStack {
                    Image(systemName: "star.square").resizable().opacity(0.3)
                }.frame(width: 25, height: 25, alignment: .top)
                .padding(.bottom,5)
                }
            }
            .padding(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 15))
            .border(Color.gray ,width: 0.3)
            
        }.buttonStyle(PlainButtonStyle())
    }
}


struct StoreRowView_Previews: PreviewProvider {
    static var previews: some View {
        StoreRowView(item: StoreMarker(name: "Carrefour testtttttttttttttttttttttttttttttttttttttttttttttttttttt", latitude: 0, longitude: 0, mallType: "asd", city: "Madrid", distance: 0, postalCode: "06200", address: "C/pedro", timetable: "123", festiveTimetable: "321", wifiActive: true, carrefourPayActive: true, storeServices: ["Entrega","salida"]), rowSelected: true)
    }
}
