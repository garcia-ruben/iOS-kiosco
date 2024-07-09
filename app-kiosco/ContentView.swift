//
//  ContentView.swift
//  app-kiosco
//
//  Created by Rubén García Pérez on 09/07/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "wifi")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hola Mundo!")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
