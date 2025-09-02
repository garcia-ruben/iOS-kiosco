//__filename__   : detalle.swift
//__author__     : DataHome S. de R.L. de C.V.
//__copyright__  : DataHome S. de R.L. de C.V.
//__description__: Vista de detalle de venta
//__version__    : 1.0.0
//__app__        : DW - Kiosco

import SwiftUI

struct Detalle: View {
   @State private var folio: String = ""
   @State private var total: String = ""
   @State private var total_formateado: Double = 0.0
   @State private var logo_empresa: Image?
   @State private var error_total = false
   @State private var existe_venta: Bool = false
   @State private var mostrar_modal: Bool = false
   @State private var venta: [[String: Any]] = []
   
   var empresa: [String: Any] = [:]
   var token: String = ""
   var body: some View {
      ZStack {
         color_background.edgesIgnoringSafeArea(.all)
         VStack {
            // Header
            Header(titulo: "venta")
            ScrollView {
               VStack {
                  // Sección de ayuda
                  HStack {
                     Text(
                        "¿Dónde encontrar la referencia de la venta?"
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
                  .padding(.bottom, 5)
                  // Panel detalles de la empresa
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
                           maxHeight: 300
                        )
                     HStack {
                        if let logo_b64 = empresa["logo"] as? String,
                           let logo_decode = Data(base64Encoded: logo_b64),
                           let logo_img = UIImage(data: logo_decode) {
                           Image(uiImage: logo_img)
                              .resizable()
                              .aspectRatio(contentMode: .fit)
                              .frame(width: 80)
                              .padding(20)
                        } else {
                           Text("No se encontró imagen")
                              .foregroundStyle(color_primary)
                              .padding(10)
                        }
                        Divider()
                        // Detalles de la empresa encontrada
                        let tabla_empresa: [(titulo: String, clave: String)] = [
                           ("Nombre o razón social:", "razon_social"),
                           ("RFC:", "registro_fiscal"),
                           ("Nombre comercial:", "nombre"),
                           ("Referencia de empresa:", "referencia_empresa")
                        ]
                        VStack {
                           ForEach(tabla_empresa, id: \.clave) { item in
                              VStack {
                                 Text(item.titulo)
                                    .font(.Poppins(tamaño: 16, estilo: "bold"))
                                    .foregroundColor(color_primary.opacity(0.5))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                 
                                 Text(empresa[item.clave] as? String ?? "N/D")
                                    .font(.Poppins(tamaño: 16, estilo: "bold"))
                                    .foregroundColor(color_primary)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                              }
                           }.padding(.bottom, 5)
                        }
                     }
                  }
                  .padding(.bottom, 10)
                  // Panel buscador de venta
                  VStack {
                     VStack {
                        Text("Referencia de la venta:")
                           .font(
                              .Poppins(
                                 tamaño: 16,
                                 estilo: "bold"
                              )
                           )
                           .foregroundColor(color_primary)
                           .frame(
                              maxWidth: .infinity,
                              alignment: .leading
                           )
                           .padding(.top, 5)
                           .padding(.bottom, 5)
                        HStack {
                           ZStack {
                              RoundedRectangle(cornerRadius: 8)
                                 .fill(Color.white)
                              HStack {
                                 Image(systemName: "barcode")
                                    .foregroundColor(color_primary)
                                    .font(
                                       Font.system (
                                          size: 18,
                                          weight: .bold
                                       )
                                    )
                                 Divider()
                                 ZStack (alignment: .leading) {
                                    if folio.isEmpty {
                                       Text ("Ej.: 12345678")
                                          .foregroundStyle(color_primary.opacity(0.3))
                                          .font(.Poppins(tamaño: 16))
                                    }
                                    TextField(
                                       "",
                                       text: $folio
                                    )
                                    .font(.Poppins(tamaño: 16))
                                    .foregroundColor(color_primary)
                                 }
                              }
                              .padding(10)
                           }
                           .frame(height: 50)
                           .cornerRadius(10)
                        }
                        .shadow(
                           color: Color.black
                              .opacity(0.2),
                           radius: 4,
                           x: 0,
                           y: 2
                        )
                     }
                     .padding(.bottom, 5)
                     VStack {
                        Text("Total de la venta:")
                           .font(
                              .Poppins(
                                 tamaño: 16,
                                 estilo: "bold"
                              )
                           )
                           .foregroundColor(color_primary)
                           .frame(
                              maxWidth: .infinity,
                              alignment: .leading
                           )
                           .padding(.top, 5)
                           .padding(.bottom, 5)
                        HStack {
                           ZStack {
                              RoundedRectangle(cornerRadius: 8)
                                 .fill(Color.white)
                              HStack {
                                 Image(systemName: "dollarsign")
                                    .foregroundColor(color_primary)
                                    .font(
                                       Font.system (
                                          size: 18,
                                          weight: .bold
                                       )
                                    )
                                 Divider()
                                 ZStack (alignment: .leading) {
                                    if total.isEmpty {
                                       Text ("0")
                                          .foregroundStyle(color_primary.opacity(0.3))
                                          .font(.Poppins(tamaño: 16))
                                    }
                                    TextField(
                                       "",
                                       text: $total
                                    )
                                    .font(.Poppins(tamaño: 16))
                                    .foregroundColor(color_primary)
                                    .onChange(of: total) {
                                       total_formateado = Double(
                                          total.replacingOccurrences(
                                             of: "[^\\d.]",
                                             with: "",
                                             options: .regularExpression
                                          )) ?? 0.0
                                       if total_formateado == 0.0 {
                                          error_total = true
                                       } else {
                                          error_total = false
                                       }
                                    }
                                 }
                              }
                              .padding(10)
                           }
                           .frame(height: 50)
                           .cornerRadius(10)
                        }
                        .shadow(
                           color: Color.black
                              .opacity(0.2),
                           radius: 4,
                           x: 0,
                           y: 2
                        )
                        if error_total {
                           Text("Por favor, verifique sus datos")
                              .font(.Poppins(tamaño: 12, estilo: "medium"))
                              .foregroundStyle(Color.red)
                              .padding(.top, 5)
                              .padding(.leading, 10)
                              .frame(maxWidth: .infinity, alignment: .leading)
                        }
                     }
                     HStack {
                        Button (action: {
                           if !error_total {
                              api_buscar_venta(
                                 token: token,
                                 folio: folio,
                                 total: total_formateado,
                                 referencia_empresa: empresa["referencia_empresa"] as? String ?? ""
                              ) { resultado in
                                 if let exito = resultado["exito"] as? Bool, exito {
                                    existe_venta = true
                                    venta = (resultado["datos"] as? [[String: Any]])!
                                 } else {
                                    mostrar_modal = true
                                 }
                              }
                           }
                        }) {
                           Text("Buscar")
                              .padding(10)
                              .frame(maxWidth: .infinity)
                              .foregroundColor(Color.white)
                              .font(
                                 .Poppins(tamaño: 18, estilo: "bold")
                              )
                              .background(color_main)
                              .cornerRadius(10)
                              .padding(.top, 5)
                        }
                        .disabled(folio.isEmpty || total.isEmpty && !error_total)
                     }
                  }
                  .padding(.bottom, 10)
               }
               .padding(10)
            }
         }
      }
      .background(color_background)
      .navigationDestination(isPresented: $existe_venta) {
         if !empresa.isEmpty {
            Facturar(venta: venta, token: token)
               .navigationBarBackButtonHidden(true)
            // Toolbar personalizado
               .toolbar {
                  ToolbarItem(placement: .navigationBarLeading) {
                     Button(action: {
                        existe_venta = false
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
      .sheet(isPresented: $mostrar_modal) {
         Modal(
            titulo: "¡No se ha encontrado ninguna venta!",
            mensaje: "Por favor verifica tus datos e inténtalo nuevamente"
         )
      }
   }
}

#Preview {
   Detalle(empresa: ["exito": true])
}
