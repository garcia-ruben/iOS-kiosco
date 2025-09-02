//
//  error.swift
//  app-kiosco
//
//  Created by Rubén García Pérez on 15/07/24.
//

import SwiftUI

struct Modal: View {
   var titulo: String = ""
   var mensaje: String = ""
    var body: some View {
       ZStack {
          color_background.edgesIgnoringSafeArea(.all)
          VStack {
             Image(systemName: "exclamationmark.magnifyingglass")
                .foregroundColor(color_main)
                .font(
                  Font.system(
                     size: 110,
                     weight: .bold
                  )
                )
             VStack {
                Text(titulo)
                Divider()
                Text(mensaje)
                   .multilineTextAlignment(.center)
                   .frame(maxWidth: .infinity)
             }
             .padding(.top, 10)
             .foregroundColor(color_primary)
          }
          .font(.Poppins(tamaño: 18, estilo: "semibold"))
          .frame(maxWidth: .infinity, maxHeight: .infinity)
          .multilineTextAlignment(.center)
       }
    }
}

#Preview {
    Modal(
      titulo: "¡No se ha encontrado ninguna empresa",
      mensaje: "Por favor verifica tus datos e inténtalo nuevamente"
    )
}
