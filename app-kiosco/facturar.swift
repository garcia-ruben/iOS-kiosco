//__filename__   : facturar.swift
//__author__     : DataHome S. de R.L. de C.V.
//__copyright__  : DataHome S. de R.L. de C.V.
//__description__: Vista de facturación de la venta
//__version__    : 1.0.0
//__app__        : DW - Kiosco


import SwiftUI

struct Facturar: View {
   @State private var comprobante: Data? = nil
   @State private var mostrar_pdf: Bool = false
   @State private var facturada: Bool = false
   @State private var mostrar_modal: Bool = false
   @State private var detalles: [String: Any] = [:]
   var venta: [[String: Any]] = []
   var token: String = ""
   var body: some View {
      ZStack {
         color_background.edgesIgnoringSafeArea(.all)
         VStack {
            // Header
            Header(titulo: "factura")
            ScrollView {
               VStack {
                  ZStack {
                     RoundedRectangle(cornerRadius: 8)
                        .fill(Color.white)
                        .shadow(
                           color: Color.black
                              .opacity(0.1),
                           radius: 4,
                           x: 0,
                           y: 2
                        )
                        .frame(
                           minHeight: 250,
                           maxHeight: 350
                        )
                     HStack {
                        // Detalles de la venta encontrada
                        let tabla_venta: [(titulo: String, clave: String)] = [
                           ("Folio:", "folio_venta"),
                           ("Fecha:", "fecha_hora"),
                           ("Moneda:", "tipo_moneda"),
                           ("Forma de pago:", "tipo_cobro"),
                           ("Subtotal:", "subtotal"),
                           ("Descuentos:", "descuento"),
                           ("Impuestos:", "impuestos"),
                           ("Retenciones:", "retenciones"),
                           ("IVA:", "iva"),
                           ("Total:", "total_importe")
                        ]
                        let valores_precios = [
                           "subtotal", "descuento", "impuestos",
                           "retenciones", "iva", "total_importe"
                        ]
                        VStack {
                           ForEach(tabla_venta.prefix(5), id: \.clave) { item in
                              VStack {
                                 Text(item.titulo)
                                    .font(.Poppins(tamaño: 16, estilo: "bold"))
                                    .foregroundColor(color_primary.opacity(0.5))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                 
                                 VStack {
                                    if valores_precios.contains(item.clave) {
                                       Text("$\(venta.first { $0[item.clave] != nil }?[item.clave] as? Double ?? 0.0, specifier: "%.2f")")
                                    } else {
                                       Text("\(venta.first { $0[item.clave] != nil }?[item.clave] ?? "N/D")")
                                    }
                                 }
                                 .font(.Poppins(tamaño: 16, estilo: "bold"))
                                 .foregroundColor(color_primary)
                                 .frame(maxWidth: .infinity, alignment: .leading)
                              }
                           }.padding(.bottom, 2)
                        }.padding()
                        Divider().padding(.horizontal, 10)
                        
                        VStack {
                           ForEach(tabla_venta.suffix(5), id: \.clave) { item in
                              VStack {
                                 Text(item.titulo)
                                    .font(.Poppins(tamaño: 16, estilo: "bold"))
                                    .foregroundColor(color_primary.opacity(0.5))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                 
                                 VStack {
                                    if valores_precios.contains(item.clave) {
                                       Text("$\(venta.first { $0[item.clave] != nil }?[item.clave] as? Double ?? 0.0, specifier: "%.2f")")
                                    } else {
                                       Text("\(venta.first { $0[item.clave] != nil }?[item.clave] ?? "N/D")")
                                    }
                                 }
                                 .font(.Poppins(tamaño: 16, estilo: "bold"))
                                 .foregroundColor(color_primary)
                                 .frame(maxWidth: .infinity, alignment: .leading)
                              }
                           }.padding(.bottom, 2)
                        }.padding()
                     }
                     .padding(.bottom, 10)
                  }
                  HStack {
                     Button (action: {
                        crear_archivo(
                           nombre: "prueba",
                           tipo: "pdf",
                           contenido: (venta.first!["nota_pdf"] as? String)!
                        )
                     }) {
                        Text("Ver comprobante")
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
                  .padding(.bottom, 5)
                  HStack {
                     Button (action: {
                        print(127)
                        api_facturar(
                           referencia_empresa: venta.first!["referencia_empresa"] as? String ?? "",
                           referencia_venta: venta.first!["referencia_venta"] as? String ?? ""
                        ) { resultado in
                           if let exito = resultado["exito"] as? Bool, exito {
                              facturada = true
                              detalles = resultado["detalles"] as! [String : Any]
                           } else {
                              mostrar_modal = true
                           }
                        }
                     })
                     {
                        Text("Facturar")
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
      }
      .navigationDestination(isPresented: $mostrar_pdf) {
         if let data = comprobante {
            PDF(data: data).edgesIgnoringSafeArea(.all)
               .navigationBarBackButtonHidden(true)
               // Toolbar personalizado
               .toolbar {
                  ToolbarItem(placement: .navigationBarLeading) {
                     Button(action: {
                        mostrar_pdf = false
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
      .navigationDestination(isPresented: $facturada) {
         ExitoFactura(detalles: detalles)
            .navigationBarBackButtonHidden(true)
            // Toolbar personalizado
            .toolbar {
               ToolbarItem(placement: .navigationBarLeading) {
                  Button(action: {
                     mostrar_pdf = false
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

#Preview {
   Facturar(venta: [])
}
