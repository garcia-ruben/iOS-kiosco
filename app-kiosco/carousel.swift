//__filename__   : carousel.swift
//__author__     : DataHome S. de R.L. de C.V.
//__copyright__  : DataHome S. de R.L. de C.V.
//__description__: Vista de inicio
//__version__    : 1.0.0
//__app__        : DW - Kiosco

import SwiftUI

struct Carousel: View {
   let elementos = [
      (
         "rectangle.and.text.magnifyingglass",
         "Paso 1: Buscar la empresa"
      ),
      (
         "cart",
         "Paso 2: Buscar la venta a facturar"
      ),
      (
         "doc.on.doc",
         "Paso 3: Realizar la factura y descargar comprobantes"
      )
   ]
   
   var body: some View {
      TabView {
         ForEach(elementos, id: \.0) {
            elemento in
            VStack {
               Image(systemName: elemento.0)
                  .foregroundColor(Color.white)
                  .font(
                     Font.system (
                        size: 100,
                        weight: .medium
                     )
                  )

               Text(elemento.1)
                  .font(.Poppins (
                     tamaño: 16,
                     estilo: "medium"
                  ))
                  .foregroundColor(.white)
                  .frame(maxWidth: .infinity)
                  .multilineTextAlignment(.center)
                  .padding(10)
            }
         }
         .padding()
      }
      .tabViewStyle(PageTabViewStyle())
      .indexViewStyle(
         PageIndexViewStyle(
            backgroundDisplayMode: .always
         )
      )
      .frame(height: 300)
   }
}

#Preview {
    Carousel()
}
