//__filename__   : funciones_inicio.swift
//__author__     : DataHome S. de R.L. de C.V.
//__copyright__  : DataHome S. de R.L. de C.V.
//__description__: Funciones para la vista de inicio
//__version__    : 1.0.0
//__app__        : DW - Kiosco

import Foundation

func api_genera_token(resultado: @escaping (Result< [String: Any], Error>) -> Void) {
   guard let url = URL(string: "\(host_admin)/fuggerbooks/ws/ws_genera_token") else { return }
   do {
      var request = URLRequest(url: url)
      request.httpMethod = "GET"
      sesion.dataTask(with: url) {
         datos,
         respuesta,
         error in
         if let error = error {
            resultado(.failure(error))
            return
         }
         
         guard let datos = datos else {
            let error = NSError(domain: "Error al recibir datos", code: 0, userInfo: nil)
            resultado(.failure(error))
            return
         }
         do {
            if let json = try JSONSerialization.jsonObject(with: datos, options: []) as? [String: Any] {
               resultado(.success(json))
            } else {
               let error = NSError(domain: "Respuesta inválida", code: 0, userInfo: nil)
               resultado(.failure(error))
            }
         } catch {
            resultado(.failure(error))
         }
      }.resume()
   }
}

func api_buscar_empresa(
   token: String,
   referencia: String,
   resultado: @escaping ([String: Any]) -> Void
) {
   guard let url = URL(string: "\(host_admin)/fuggerbooks/ws/ws_buscar_empresa") else {
      resultado(mensaje_error)
      return
   }
   do {
      let datos = [
         "token": token,
         "referencia": referencia.uppercased()
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
         do {
            guard let empresa = try JSONSerialization.jsonObject(with: datos, options: []) as? [String: Any] else {
               resultado(mensaje_error)
               return
            }
            resultado(empresa)
         } catch {
            resultado(mensaje_error)
         }
      }.resume()
   } catch {
      resultado(mensaje_error)
      return
   }
}
