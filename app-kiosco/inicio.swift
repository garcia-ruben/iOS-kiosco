//__filename__   : vista_encabezado.swift
//__author__     : DataHome S. de R.L. de C.V.
//__copyright__  : DataHome S. de R.L. de C.V.
//__description__: Vista de inicio
//__version__    : 1.0.0
//__app__        : DW - Kiosco

import SwiftUI

struct Inicio: View {
   @State private var busqueda = ""

   var body: some View {
      ScrollView {
         VStack(spacing: 0) {
            VStack {
               // Header
               HStack {
                  VStack {
                     Image("kiosco-logo")
                        .resizable()
                        .aspectRatio( contentMode: .fit )
                        .frame(width: 70)
                  }
                  VStack {
                     Text(
                        "Portal de facturación."
                     ).font(
                        .Poppins (
                           tamaño: 19,
                           estilo: "bold"
                        )
                     )
                     .foregroundColor(color_main)
                     .frame(
                        maxWidth: .infinity,
                        alignment: .leading
                     )
                     
                     Text("Buscador de empresas.")
                        .font(.Poppins (
                           tamaño: 23,
                           estilo: "bold")
                        )
                        .foregroundColor(color_primary)
                        .frame(
                           maxWidth: .infinity,
                           alignment: .leading
                        )
                  }
               }
               .padding(10)
               
               VStack {
                  // Sección de ayuda
                  HStack {
                     Text(
                        "¿Dónde encontrar la referencia de empresa?"
                     )
                     .foregroundColor(color_primary)
                     
                     Button( action: {
                        print("Ayuda")
                     }) {
                        Image(systemName: "questionmark.circle")
                           .foregroundColor(color_main)
                           .font(
                              Font.system (
                                 size: 14,
                                 weight: .bold
                              )
                           )
                     }
                  }
                  .font(.Poppins(tamaño: 14))
                  .frame(maxWidth: .infinity)
                  
                  // Panel buscador de empresas
                  HStack {
                     ZStack {
                        RoundedRectangle(cornerRadius: 8)
                           .fill(Color.white)
                        HStack {
                           Image(systemName: "building.2")
                              .foregroundColor(color_primary)
                              .font(
                                 Font.system (
                                    size: 30,
                                    weight: .bold
                                 )
                              )
                           Divider()
                           ZStack (alignment: .leading) {
                              if busqueda.isEmpty {
                                 Text ("Referencia de empresa")
                                 .foregroundStyle(color_primary.opacity(0.3))
                                 .font(.Poppins(tamaño: 16))
                              }
                              TextField(
                                 "",
                                 text: $busqueda
                              )
                              .font(.Poppins(tamaño: 16))
                              .foregroundColor(color_primary)
                           }
                        }
                        .padding(10)
                     }
                     .cornerRadius(10)
                     
                     Button (action: {
                        print("Buscar")
                     }) {
                        Image(systemName: "magnifyingglass")
                           .foregroundColor(Color.white)
                           .font(
                              Font.system (
                                 size: 20,
                                 weight: .bold
                              )
                           )
                           .padding(15)
                           .frame(height: 100)
                           .background(color_main)
                           .cornerRadius(10)
                     }
                  }
                  .frame(height: 100)
                  .shadow(
                     color: Color.black
                        .opacity(0.5),
                     radius: 4,
                     x: 0,
                     y: 2
                  )
               }
               .padding(10)
            }
            .frame(height: 500)
            VStack {
               Carousel()
               .background(color_primary)
            }
         }
      }
      .background(color_background)
   }
}

#Preview {
   Inicio()
}
