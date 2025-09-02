//__filename__   : header.swift
//__author__     : DataHome S. de R.L. de C.V.
//__copyright__  : DataHome S. de R.L. de C.V.
//__description__: Header dinámico para la app
//__version__    : 1.0.0
//__app__        : DW - Kiosco

import SwiftUI

struct Header: View {
   var titulo: String
    var body: some View {
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
             
             Text(
               titulo == "venta" ? "Busque la venta." : (
                  titulo == "empresa" ? "Buscador de empresas." : (
                     titulo == "factura" ? "Realice su factura" : ""
                  )
               )
             )

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
    }
}

#Preview {
    Header(titulo: "factura")
}
