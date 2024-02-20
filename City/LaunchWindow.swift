//
//  LaunchWindow.swift
//  City
//
//  Created by Arun Kulkarni on 19/02/24.
//

import SwiftUI

struct LaunchWindow: Scene {
    var viewModel: ViewModel

    var body: some Scene {
        WindowGroup(id: "LaunchWindow") {
            WelcomeView().environment(viewModel)
        }.windowStyle(.volumetric).defaultSize(width: 0.7, height: 0.7, depth: 0.0, in: .meters)
    }
}
