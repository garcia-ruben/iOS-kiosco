//
//  app_kioscoApp.swift
//  app-kiosco
//
//  Created by Rubén García Pérez on 09/07/24.
//

import SwiftUI

class Estado: ObservableObject {
   @Published var cargando: Bool = true
}

@main
struct app_kioscoApp: App {
   @StateObject private var estado = Estado()
   @State private var token: String = ""
   
   var body: some Scene {
      WindowGroup {
         Contenido(token: $token)
            .environmentObject(estado)
            .onAppear {
               api_genera_token {
                  resultado in
                  if let json = try? resultado.get(),
                     let token = json["token"] as? String {
                     self.token = token
                     estado.cargando = false
                  }
               }
            }
      }
   }
}

struct Contenido: View {
   @EnvironmentObject var estado: Estado
   @Binding var token: String
   
   var body: some View {
      VStack {
         if estado.cargando {
            Splash()
         } else {
            NavigationStack {
               ZStack {
                  color_background.edgesIgnoringSafeArea(.all)
                  VStack {
                     Inicio(token: token)
                  }
               }
            }
         }
      }
   }
}
