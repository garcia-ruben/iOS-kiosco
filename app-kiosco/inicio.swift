//__filename__   : vista_encabezado.swift
//__author__     : DataHome S. de R.L. de C.V.
//__copyright__  : DataHome S. de R.L. de C.V.
//__description__: Vista de inicio
//__version__    : 1.0.0
//__app__        : DW - Kiosco

import SwiftUI

struct Inicio: View {
   @State private var busqueda = ""
   @State private var empresa: [String: Any] = [:]
   @State private var logo_empresa: Image?
   @State private var existe_empresa: Bool = false
   @State private var mostrar_modal: Bool = false
   var token: String = ""
   
   var body: some View {
      ZStack {
         color_background.edgesIgnoringSafeArea(.all)
         VStack {
            // Header
            Header(titulo: "empresa")
            ScrollView {
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
                              TextField("", text: $busqueda)
                                 .font(.Poppins(tamaño: 16))
                                 .foregroundColor(color_primary)
                                 .frame(maxHeight: .infinity)
                           }
                        }
                        .padding(10)
                     }
                     .cornerRadius(10)
                     
                     Button(action: {
                        api_buscar_empresa(
                           token: token,
                           referencia: busqueda
                        ) { resultado in
                           if let exito = resultado["exito"] as? Bool, exito {
                              empresa = resultado
                              if let logo_b64 = empresa["logo"] as? String,
                                 let logo_decode = Data(base64Encoded: logo_b64),
                                 let logo_img = UIImage(data: logo_decode) {
                                 logo_empresa = Image(uiImage: logo_img)
                              }
                              existe_empresa = true
                           } else {
                              mostrar_modal = true
                           }
                        }
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
            Carousel().background(color_primary)
         }
      }
      .navigationDestination(isPresented: $existe_empresa) {
         if !empresa.isEmpty {
            Detalle(empresa: empresa, token: token)
               .navigationBarBackButtonHidden(true)
            // Toolbar personalizado
               .toolbar {
                  ToolbarItem(placement: .navigationBarLeading) {
                     Button(action: {
                        // 0.3s de tiempo para regresarse al buscador de empresas
                        // ya que si se hace muy rápido no regresa correctamente
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                           existe_empresa = false
                        }
                        print(existe_empresa)
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
            titulo: "¡No se ha encontrado ninguna empresa!",
            mensaje: "Por favor verifica tus datos e inténtalo nuevamente"
         )
      }
   }
}

#Preview {
   Inicio()
}
