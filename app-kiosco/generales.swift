//__filename__   : generales.swift
//__author__     : DataHome S. de R.L. de C.V.
//__copyright__  : DataHome S. de R.L. de C.V.
//__description__: Contiene variables y funciones generales
//__version__    : 1.0.0
//__app__        : DW - Kiosco

import Foundation
import SwiftUI
import PDFKit
import WebKit

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
      if !estilo.isEmpty && estilos.contains(estilo.lowercased())  {
         fuente = "Poppins-" + estilo
      }
      return Font.custom(
         fuente,
         size: tamaño
      )
   }
}

enum JSONError: Error {
   case serializationError
}

func convertirDatosAJSON(_ datos: [String: Any]) throws -> Data {
   do {
      let datosJSON = try JSONSerialization.data(withJSONObject: datos)
      return datosJSON
   } catch {
      throw JSONError.serializationError
   }
}

// Variables para consumir las APIS
let host_admin = "https://10.90.10.22:9015"
let host_microservicio = "http:127.0.0.1:8001"
let mensaje_error: [String: Any] = [
   "exito": false,
   "mensaje": "Error en la solicitud"
]

// Deshabilita la verificación SSL
class URLSessionDelegateHandler: NSObject, URLSessionDelegate {
   func urlSession(_
      session: URLSession,
      didReceive challenge: URLAuthenticationChallenge,
      completionHandler: @escaping (
         URLSession.AuthChallengeDisposition,
         URLCredential?
      ) -> Void
   ) {
      if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
         if let serverTrust = challenge.protectionSpace.serverTrust {
            let credential = URLCredential(trust: serverTrust)
            completionHandler(.useCredential, credential)
         } else {
            completionHandler(.performDefaultHandling, nil)
         }
      } else {
         completionHandler(.performDefaultHandling, nil)
      }
   }
}

let delegate = URLSessionDelegateHandler()
let sesion = URLSession (
   configuration: .default,
   delegate: delegate,
   delegateQueue: nil
)

struct PDF: UIViewRepresentable {
   let data: Data
   
   func makeUIView(context: Context) -> PDFView {
      let vistaPDF = PDFView()
      vistaPDF.autoScales = true
      return vistaPDF
   }
   
   func updateUIView(_ vistaPDF: PDFView, context: Context) {
      if let documento = PDFDocument(data: data) {
         vistaPDF.document = documento
      }
   }
}

func crear_archivo(nombre: String, tipo: String, contenido: String) {
   guard let ruta_archivo = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
      print("No se pudo obtener el directorio de documentos.")
      return
   }
   
   let ruta_completa = ruta_archivo.appendingPathComponent("\(nombre).\(tipo)")
   
   do {
      switch tipo {
      case "pdf":
         let pdf_decode = Data(base64Encoded: contenido, options: .ignoreUnknownCharacters)
         try pdf_decode!.write(to: ruta_completa)
         elegir_ruta(ruta_completa)
         print("Archivo PDF creado correctamente en: \(ruta_completa.path)")
         
      case "xml":
         try contenido.write(to: ruta_completa, atomically: true, encoding: .utf8)
         print("Archivo XML creado correctamente en: \(ruta_completa.path)")
      default:
         print("ND")
      }
   }catch {
      print("Error al crear el archivo \(nombre): \(error.localizedDescription)")
   }
}

func elegir_ruta(_ url: URL) {
   let selector = UIDocumentPickerViewController(forExporting: [url])
   selector.delegate = UIApplication.shared.connectedScenes
      .compactMap { $0 as? UIWindowScene }
      .flatMap { $0.windows }
      .first { $0.isKeyWindow }?.rootViewController as? UIDocumentPickerDelegate
   
   let vista = UIApplication.shared.connectedScenes
      .compactMap { $0 as? UIWindowScene }
      .flatMap { $0.windows }
      .first { $0.isKeyWindow }?.rootViewController
   
   vista?.present(selector, animated: true, completion: nil)
}
