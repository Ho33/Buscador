//
//  TEST.swift
//  Buscador_Tiendas
//
//  Created by hh3 on 11/6/20.
//

import SwiftUI

struct StoreRowView: View {
    var item: StoreMarker
    
    var body: some View {
        HStack{
            Image(getIconForInStoreLocalized(mallType: item.mallType))
                .frame(width: 60, height: 20, alignment: .center)
                .padding(.top,40)
            VStack{
                HStack{
                Text(item.name)
                    Spacer()
                }
                HStack{
                Text(item.address!).font(.system(size: 12))
                    Spacer()
                }
                HStack{
                Text(item.postalCode!).font(.system(size: 12))
                Text(item.city!).font(.system(size: 12))
                    
                    Spacer()
                }
            }
            Spacer()
            ZStack{
                Text("\(item.distance!)").font(.system(size: 12)).padding(.top,9)
            }.frame(width: 50, height: 60, alignment: .top)
        }.frame(width: 355, height: 60, alignment: .center)
        .border(Color.gray ,width: 0.3)
    }
}

struct StoreRowView_Previews: PreviewProvider {
    static var previews: some View {
        StoreRowView(item: StoreMarker(name: "Carrefour express Principe", latitude: 0, longitude: 0, mallType: "asd",city: "madrid", distance: 200, postalCode: "0123", address: "Calle los alamos, 32"))
    }
}
