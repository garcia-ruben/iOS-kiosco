//__filename__   : generales.swift
//__author__     : DataHome S. de R.L. de C.V.
//__copyright__  : DataHome S. de R.L. de C.V.
//__description__: Contiene variables y funciones generales
//__version__    : 1.0.0
//__app__        : DW - Kiosco

import Foundation
import SwiftUI

// DISEÑO
let color_main = Color (
   UIColor (
      red: 0.1,
      green: 0.72,
      blue: 0.35,
      alpha: 1
   )
)

let color_primary = Color (
   UIColor (
      red: 0.26,
      green: 0.30,
      blue: 0.36,
      alpha: 1
   )
)

let color_background = Color (
   UIColor (
      red: 0.92,
      green: 0.94,
      blue: 0.96,
      alpha: 1
   )
)

extension Font {
   static func Poppins(
      tamaño: CGFloat,
      estilo: String = ""
   ) -> Font {
      var fuente = "Poppins-Regular"
      let estilos = [
         "black", "bold", "bolditalic",
         "italic", "light", "extrabold",
         "medium", "thin"
      ]
      if !estilo.isEmpty {
         if estilos.contains(estilo.lowercased())  {
            fuente = "Poppins-" + estilo
         }
      }
      return Font.custom(
         fuente,
         size: tamaño
      )
   }
}
