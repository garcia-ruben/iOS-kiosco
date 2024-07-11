//__filename__   : vista_encabezado.swift
//__author__     : DataHome S. de R.L. de C.V.
//__copyright__  : DataHome S. de R.L. de C.V.
//__description__: Vista inicial de la app
//__version__    : 1.0.0
//__app__        : DW - Kiosco

import SwiftUI

struct Splash: View {
   @Environment(\.colorScheme) var tema
   var body: some View {
      let color_main = tema == .dark ? 
         color_primary : color_main
      return ZStack {
         color_main
         .edgesIgnoringSafeArea(.all)
         VStack {
            Spacer()
            Image("kiosco-logo")
               .resizable()
               .frame(width: 150, height: 150)
            Spacer()
         }
      }
   }
}

#Preview {
    Splash()
}
