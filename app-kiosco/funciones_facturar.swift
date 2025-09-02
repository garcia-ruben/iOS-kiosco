//__filename__   : funciones_facturar.swift
//__author__     : DataHome S. de R.L. de C.V.
//__copyright__  : DataHome S. de R.L. de C.V.
//__description__: Funciones para la vista de facturación
//__version__    : 1.0.0
//__app__        : DW - Kiosco

import Foundation

func api_facturar(
   referencia_empresa: String,
   referencia_venta: String,
   resultado: @escaping ([String: Any]
) -> Void) {
   guard let url = URL(string: "\(host_microservicio)/ws_facturar_generar_pdf/") else {
      resultado(mensaje_error)
      return
   }
   
   let parametros: [String: Any] = [
      "referencia_empresa": referencia_empresa.uppercased(),
      "referencia_venta": referencia_venta
   ]
   let datos = parametros.map { "\($0.key)=\($0.value)" }.joined(separator: "&")
   var request = URLRequest(url: url)
   request.httpMethod = "POST"
   // Si no se envía de esta manera Django no reconoce los parámetros
   request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
   request.httpBody = datos.data(using: .utf8)
      
   sesion.dataTask(with: request) {
      datos,
      respuesta,
      error in
      guard let datos = datos else {
         resultado(mensaje_error)
         return
      }
      // print(String(data: datos, encoding: .utf8) ?? "No se puede convertir a UTF-8")
      do {
         guard
            let factura = try JSONSerialization.jsonObject(with: datos, options: []) as? [String: Any] else {
            resultado(mensaje_error)
            return
         }
         resultado(factura)
      }
      catch {
         resultado(mensaje_error)
      }
   }.resume()
}
