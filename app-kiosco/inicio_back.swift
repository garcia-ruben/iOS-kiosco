//__filename__   : inicio_back.swift
//__author__     : DataHome S. de R.L. de C.V.
//__copyright__  : DataHome S. de R.L. de C.V.
//__description__: Funciones para la vista de inicio
//__version__    : 1.0.0
//__app__        : DW - Kiosco

import Foundation

let host_admin = "https://develop5.datawork.mx:9009"
let host_microservicio = "http://35.162.161.74:9001"

func api_genera_token(resultado: @escaping (Result < String, Error>) -> Void) {
   guard let url = URL(string: "\(host_admin)/fuggerbooks/ws/ws_genera_token") else {
      return
   }
   var request = URLRequest(url: url)
   request.httpMethod = "GET"
   
   let noSSL = URLSessionConfiguration.default
   noSSL.timeoutIntervalForRequest = 15.0
   noSSL.timeoutIntervalForResource = 30.0
   noSSL.httpShouldSetCookies = false
   noSSL.httpShouldUsePipelining = true
   
   let sesion = URLSession(configuration: noSSL)
   let tarea = sesion.dataTask(with: request) {
      (
         datos,
         respuesta,
         error
      ) in
      if let error = error {
         resultado(.failure(error))
         return
      }
      guard let httpResponse = respuesta as? HTTPURLResponse, httpResponse.statusCode == 200 else {
         resultado(.failure(NSError(domain: "Respuesta inválida del servidor", code: 0, userInfo: nil)))
         return
      }
      if let datos = datos {
         do {
            if let token = String(data: datos, encoding: .utf8) {
               resultado(.success(token))
               print("Token obtenido: \(token)")
            } else {
               resultado(.failure(NSError(domain: "Error al decodificar el token", code: 0, userInfo: nil)))
            }
         }
      }
   }
   tarea.resume()
}
