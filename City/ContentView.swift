//
//  ContentView.swift
//  City
//
//  Created by Arun Kulkarni on 16/02/24.
//

import SwiftUI
import Foundation
import RealityKit
import RealityKitContent
import Observation
import MapKit

struct ContentView: View {

    @State private var enlarge = false
    @State private var showImmersiveSpace = false
    @State private var immersiveSpaceIsShown = false

    @Environment(\.openImmersiveSpace) var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) var dismissImmersiveSpace
    @State private var attachmentsProvider = AttachmentsProvider()

    var viewModel: ViewModel
    @State private var position: MapCameraPosition = .automatic

    var body: some View {
        @Bindable var viewModel = viewModel
        
//        Trying to place content on place.
//        RealityView { content in
//            content.add(viewModel.setupContentEntity())
//            
//            // Add the initial RealityKit content
//            if let immersiveContentEntity = try? await Entity(named: "Immersive", in: realityKitContentBundle) {
//                immersiveContentEntity.transform.translation += SIMD3<Float>(0.0, 1.0, 0.0)
//                content.add(immersiveContentEntity)
//
//                // Add an ImageBasedLight for the immersive content
//                guard let resource = try? await EnvironmentResource(named: "ImageBasedLight") else { return }
//                let iblComponent = ImageBasedLightComponent(source: .single(resource), intensityExponent: 0.25)
//                immersiveContentEntity.components.set(iblComponent)
//                immersiveContentEntity.components.set(ImageBasedLightReceiverComponent(imageBasedLight: immersiveContentEntity))
//
//                // Put skybox here.  See example in World project available at
//                // https://developer.apple.com/
//            }
//        }

        VStack {
            VStack {
                Button("Empire State building") {
                    viewModel.updateScale()
                    self.showImmersiveSpace = true
                }
                Button("Map View") {
                    viewModel.resetScale()
                    self.showImmersiveSpace = false
                }
            }.padding(20).glassBackgroundEffect()

            RealityView { content  in
                do {
                    let entity = try await Entity(named: "Immersive", in: realityKitContentBundle)
                    // Add an ImageBasedLight for the immersive content
                    guard let resource = try? await EnvironmentResource(named: "ImageBasedLight") else { return }
                    let iblComponent = ImageBasedLightComponent(source: .single(resource), intensityExponent: 0.25)
                    entity.components.set(iblComponent)
                    entity.components.set(ImageBasedLightReceiverComponent(imageBasedLight: entity))

                    viewModel.rootEntity = entity
                    viewModel.resetScale()
                    content.add(entity)
//                    guard let soundEntity = viewModel.rootEntity.findEntity(named: "cityTraffic1"),
//                          let resource = try? await AudioFileResource(named: "/Root/bikes_wav",
//                                                   from: "Immersive.usda",
//                                                              in: realityKitContentBundle) else { return }
//                    let audioPlaybackController = soundEntity.prepareAudio(resource)
//                    audioPlaybackController.play()
                } catch {
                    print("Error in RealityView's make: \(error)")
                }
            }
            .onAppear {
                if viewModel.selectedPlaceInfo == nil {
                    viewModel.selectedPlaceInfo = viewModel.placeInfoList.first
                }
            }
            .onChange(of: showImmersiveSpace) { _, newValue in
                Task {
                    if newValue {
                        await openImmersiveSpace(id: "ImmersiveSpace")
                    } else {
                        await dismissImmersiveSpace()
                    }
                }
            }
        }
    }
}

#Preview(windowStyle: .volumetric) {
//    ContentView(viewModel: ViewModel())
}
