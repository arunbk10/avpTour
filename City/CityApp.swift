//
//  CityApp.swift
//  City
//
//  Created by Arun Kulkarni on 16/02/24.
//

import SwiftUI

@main
struct CityApp: App {
    @State private var viewModel = ViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: viewModel)
        }.windowStyle(.volumetric)
        
        ImmersiveSpace(id: "ImmersiveSpace") {
            ImmersiveView(viewModel: viewModel)
        }.immersionStyle(selection: .constant(.full), in: .full)
    }
}
