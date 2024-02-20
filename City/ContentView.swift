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

    @Environment(\.openImmersiveSpace) var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) var dismissImmersiveSpace
    @State private var attachmentsProvider = AttachmentsProvider()
    @State private var position: MapCameraPosition = .automatic
    @State private var subscriptions = [EventSubscription]()
    @State private var showImmersiveSpace = false
    @State private var immersiveSpaceIsShown = false

    var viewModel: ViewModel
    static let runtimeQuery = EntityQuery(where: .has(PointOfInterestRuntimeComponent.self))

    var body: some View {
        @Bindable var viewModel = viewModel
//        VStack {
//            Button("Times Square") {
//                viewModel.updateScale()
//                viewModel.selectedPlaceInfo = viewModel.placeInfoList.first
//                Task {
//                    try? await viewModel.setSnapshot()
//                }
//
//                self.showImmersiveSpace = true
//            }
//            Button("Empire State building") {
//                viewModel.updateScale()
//                viewModel.selectedPlaceInfo = viewModel.placeInfoList.last
//                Task {
//                    try? await viewModel.setSnapshot()
//                }
//
//                self.showImmersiveSpace = true
//            }
//            Button("Map View") {
//                viewModel.resetScale()
//                self.showImmersiveSpace = false
//            }
//        }.padding(20).glassBackgroundEffect()
        
        RealityView { content, _ in
            do {
                let entity = try await Entity(named: "Immersive", in: realityKitContentBundle)
                viewModel.rootEntity = entity
                guard let resource = try? await EnvironmentResource(named: "ImageBasedLight") else { return }
                let iblComponent = ImageBasedLightComponent(source: .single(resource), intensityExponent: 0.25)
                entity.components.set(iblComponent)
                entity.components.set(ImageBasedLightReceiverComponent(imageBasedLight: entity))

                viewModel.rootEntity = entity
                viewModel.resetScale()
                entity.position.y = -0.4
                entity.position.z = -0.6
                content.add(entity)
                
                subscriptions.append(content.subscribe(to: ComponentEvents.DidAdd.self, componentType: PointofInterestComponent.self, { event in
                    createLearnMoreView(for: event.entity)
                }))
                
            } catch {
                print("Error in RealityView's make: \(error)")
            }
            
        }
        update: { content, attachments in

        // Add attachment entities to marked entities. First, find all entities that have the
        // PointOfInterestRuntimeComponent, which means they've created an attachment.
            viewModel.rootEntity.scene?.performQuery(Self.runtimeQuery).forEach { entity in

            guard let component = entity.components[PointOfInterestRuntimeComponent.self] else { return }

            // Get the entity from the collection of attachments keyed by tag.
            guard let attachmentEntity = attachments.entity(for: component.attachmentTag) else { return }

            guard attachmentEntity.parent == nil else { return }

            // Have all the Point Of Interest attachments always face the camera by giving them a BillboardComponent.
//            attachmentEntity.components.set(BillboardComponent())

            // SwiftUI calculates an attachment view's expanded size using the top center as the pivot point. This
            // raises the views so they aren't sunk into the terrain in their initial collapsed state.
            entity.addChild(attachmentEntity)
            attachmentEntity.setPosition([0.0, 0.4, 0.0], relativeTo: entity)
        }
        } attachments: {
            ForEach(attachmentsProvider.sortedTagViewPairs, id: \.tag) { pair in
                Attachment(id: pair.tag) {
                    pair.view
                }
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
//                    await dismissImmersiveSpace()
//                    await openImmersiveSpace(id: "ImmersiveSpace")
                } else {
//                    await dismissImmersiveSpace()
                }
            }
        }
    }
    
    private func createLearnMoreView(for entity: Entity) {
        
        // If this entity already has a RuntimeComponent, don't add another one.
        guard entity.components[PointOfInterestRuntimeComponent.self] == nil else { return }
        
        // Get this entity's PointOfInterestComponent, which is in the Reality Composer Pro project.
        guard let pointOfInterest = entity.components[PointofInterestComponent.self] else { return }
            
        let tag: ObjectIdentifier = entity.id
        
        let view = LearnMoreView(name: pointOfInterest.name,
                                 description:  pointOfInterest.description ?? "",
                                 id: viewModel.selectedPlaceInfo,
                                 viewModel: viewModel)
            .tag(tag)
        
        entity.components[PointOfInterestRuntimeComponent.self] = PointOfInterestRuntimeComponent(attachmentTag: tag)
        
        attachmentsProvider.attachments[tag] = AnyView(view)
    }
}

#Preview(windowStyle: .volumetric) {
    ContentView(viewModel: ViewModel())
}
