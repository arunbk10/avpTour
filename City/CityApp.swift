//
//  CityApp.swift
//  City
//
//  Created by Arun Kulkarni on 16/02/24.
//

import SwiftUI
import RealityKitContent
import ARKit
import RealityKit

@main
struct CityApp: App {
    @State private var viewModel = ViewModel()

    let someWindowSize: CGFloat = 15000
    init() {
        RealityKitContent.PointofInterestComponent.registerComponent()
        PointOfInterestRuntimeComponent.registerComponent()
        RealityKitContent.BillboardComponent.registerComponent()
        
        RealityKitContent.BillboardSystem.registerSystem()
    }
    
    var body: some SwiftUI.Scene {
        LaunchWindow(viewModel: viewModel)
        DescriptionWindow()
        WindowGroup(id: "ChatView"){
            ChatView(viewModel: viewModel)
        }.windowStyle(.volumetric).defaultSize(width: 1, height: 0.8, depth: 0.0, in: .meters)
        WindowGroup (id: "ContentView"){
            ContentView(viewModel: viewModel)
        }.windowStyle(.volumetric).defaultSize(width: someWindowSize, height: someWindowSize, depth: someWindowSize)
        ImmersiveSpace(id: "ImmersiveSpace"){
            ImmersiveView(viewModel: viewModel)
        }.immersionStyle(selection: .constant(.full), in: .full)
        
        ImmersiveSpace(id: "LaunchSpace"){
            LaunchImmersiveView(viewModel: viewModel)
        }.immersionStyle(selection: .constant(.full), in: .full)
        
        ImmersiveSpace(id: "StreetSpace"){
            StreetImmersiveView(viewModel: viewModel)
        }.immersionStyle(selection: .constant(.full), in: .full)
    }
}
