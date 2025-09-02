//
//  inicio_v2.swift
//  app-kiosco
//
//  Created by Rubén García Pérez on 15/07/24.
//

import SwiftUI

struct ContentView: View {
   @State private var existe: Bool = false
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink("Ir a la Segunda Vista", destination: SecondView())
                    .padding()
            }
        }
    }
}

struct SecondView: View {
    var body: some View {
        VStack {
            Text("Segunda Vistaa")
                .font(.largeTitle)
                .padding()
        }
        .navigationTitle("Segunda Vista")
    }
//   if let logo_empresa = logo_empresa {
//      logo_empresa
//         .resizable()
//         .aspectRatio(contentMode: .fit)
//         .frame(width: 200, height: 200)
//         .cornerRadius(10)
//         .padding()
//   }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


