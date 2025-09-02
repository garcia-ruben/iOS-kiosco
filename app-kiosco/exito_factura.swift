//__filename__   : exito_factura.swift
//__author__     : DataHome S. de R.L. de C.V.
//__copyright__  : DataHome S. de R.L. de C.V.
//__description__: Vista de facturación exitosa
//__version__    : 1.0.0
//__app__        : DW - Kiosco

import SwiftUI

struct ExitoFactura: View {
   @State private var comprobante_pdf: Data? = nil
   @State private var comprobante_xml: String = ""
   @State private var descargar_pdf: Bool = false
   @State private var descargar_xml: Bool = false
   var detalles: [String: Any] = [:]
   var body: some View {
      ZStack {
         color_background.edgesIgnoringSafeArea(.all)
         VStack {
            Image(systemName: "text.badge.checkmark")
               .foregroundColor(color_main)
               .font(
                  Font.system(
                     size: 110,
                     weight: .bold
                  )
               )
            VStack {
               Text("¡Facturación exitosa!")
                  .font(.Poppins(tamaño: 26, estilo: "bold"))
               Divider().padding(.horizontal, 10)
               Text("La venta ha sido facturada corectamente, puede descargar sus comprobantes en esta pestaña o en la pestaña anterior")
                  .multilineTextAlignment(.center)
                  .frame(maxWidth: .infinity)
                  .font(.Poppins(tamaño: 18, estilo: "semibold"))
                  .padding(10)
            }
            .padding(.top, 10)
            .foregroundColor(color_primary)
            VStack {
               HStack {
                  Button (action: {
                     descargar_xml = false
                     descargar_pdf = true
                  comprobante_pdf = Data(
                        base64Encoded: (detalles["contenido_pdf"] as? String)!
                     )
                  }) {
                     Text("Descargar PDF")
                        .padding(10)
                        .frame(maxWidth: .infinity)
                        .foregroundColor(Color.white)
                        .font(
                           .Poppins(tamaño: 18, estilo: "bold")
                        )
                        .background(color_main)
                        .cornerRadius(10)
                  }
               }
               HStack {
                  Button (action: {
                     descargar_pdf = false
                     descargar_xml = true
                     comprobante_xml = detalles["contenido_xml"] as! String
                     print(65, comprobante_xml)
                  })
                  {
                     Text("Descargar XML")
                        .padding(10)
                        .frame(maxWidth: .infinity)
                        .foregroundColor(color_main)
                        .font(
                           .Poppins(tamaño: 18, estilo: "bold")
                        )
                        .background(Color.white.opacity(0))
                        .cornerRadius(10)
                        .overlay(
                           RoundedRectangle(cornerRadius: 10)
                              .strokeBorder(color_main, lineWidth: 1)
                        )
                  }
               }
            }.padding(10)
         }
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .multilineTextAlignment(.center)
      .onAppear{
         print(detalles)
      }
      .navigationDestination(isPresented: $descargar_xml) {
         ScrollView {
            Text(comprobante_xml)
               .font(.system(.body, design: .monospaced))
               .padding()
         }
         .frame(maxWidth: .infinity, maxHeight: .infinity)
         .edgesIgnoringSafeArea(.all)
         .navigationBarBackButtonHidden(true)
         // Toolbar personalizado
         .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
               Button(action: {
                  descargar_xml = false
               }) {
                  HStack {
                     Image(systemName: "chevron.backward")
                     Text("Volver")
                  }
                  .foregroundColor(color_main)
               }
            }
         }
      }
      .navigationDestination(isPresented: $descargar_pdf) {
         if let data = comprobante_pdf {
            PDF(data: data).edgesIgnoringSafeArea(.all)
               .navigationBarBackButtonHidden(true)
               // Toolbar personalizado
               .toolbar {
                  ToolbarItem(placement: .navigationBarLeading) {
                     Button(action: {
                        descargar_pdf = false
                     }) {
                        HStack {
                           Image(systemName: "chevron.backward")
                           Text("Volver")
                        }
                        .foregroundColor(color_main)
                     }
                  }
               }
         }
      }
   }
}

#Preview {
   ExitoFactura(detalles: [:])
}
