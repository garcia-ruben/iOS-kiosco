//__filename__   : funciones_detalle.swift
//__author__     : DataHome S. de R.L. de C.V.
//__copyright__  : DataHome S. de R.L. de C.V.
//__description__: Funciones para la vista de detalle
//__version__    : 1.0.0
//__app__        : DW - Kiosco

import Foundation

func api_buscar_venta(
   token: String,
   folio: String,
   total: Double,
   referencia_empresa: String,
   resultado: @escaping ([String: Any]
) -> Void) {
   guard let url = URL(string: "\(host_admin)/fuggerbooks/ws/ws_buscar_venta") else {
      resultado(mensaje_error)
      return
   }
   do {
      let datos: [String: Any] = [
         "token": token,
         "folio": folio,
         "total": total,
         "referencia_empresa": referencia_empresa.uppercased()
      ]
      var request = URLRequest(url: url)
      request.httpMethod = "POST"
      request.setValue("application/json", forHTTPHeaderField: "Content-Type")
      request.httpBody = try convertirDatosAJSON(datos)
      
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
               let venta = try JSONSerialization.jsonObject(with: datos, options: []) as? [String: Any],
               let exito = venta["exito"] as? Bool, exito == true,
            let datosVenta = venta["datos"] as? [[String: Any]], !datosVenta.isEmpty else {
                  resultado(mensaje_error)
                  return
               }
            resultado(venta)
         } catch {
            resultado(mensaje_error)
         }
      }.resume()
   } catch {
      resultado(mensaje_error)
   }
}
