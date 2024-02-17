//
//  ImmersiveView.swift
//  City
//
//  Created by Arun Kulkarni on 16/02/24.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ImmersiveView: View {
    
    var viewModel: ViewModel

    var body: some View {
        RealityView { content in
            content.add(viewModel.setupContentEntity())
            
//            // Add the initial RealityKit content
//            if let immersiveContentEntity = try? await Entity(named: "Immersive", in: realityKitContentBundle) {
//                immersiveContentEntity.transform.translation += SIMD3<Float>(0.0, 1.0, 0.0)
//                content.add(immersiveContentEntity)
//                // Add an ImageBasedLight for the immersive content
//                guard let resource = try? await EnvironmentResource(named: "ImageBasedLight") else { return }
//                let iblComponent = ImageBasedLightComponent(source: .single(resource), intensityExponent: 0.25)
//                immersiveContentEntity.components.set(iblComponent)
//                immersiveContentEntity.components.set(ImageBasedLightReceiverComponent(imageBasedLight: immersiveContentEntity))
//
//                // Put skybox here.  See example in World project available at
//                // https://developer.apple.com/
//            }
        }
        .task {
            try? await viewModel.setSnapshot()
        }
    }
}

#Preview {
    ImmersiveView(viewModel: ViewModel())
        .previewLayout(.sizeThatFits)
}
