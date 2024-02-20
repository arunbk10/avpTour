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
        
        if viewModel.isChatView
        {
            RealityView { content in
                if let scene = try? await Entity(named: "Launch", in: realityKitContentBundle) {
                    content.add(scene)
                }
            }
        }
        else
        {
            RealityView { content in
                content.add(viewModel.setupContentEntity())
            }
            .task {
                try? await viewModel.setSnapshot()
            }
        }
    }
}

struct LaunchImmersiveView: View {
    
    var viewModel: ViewModel

    var body: some View {
        RealityView { content in
            // Add the initial RealityKit content
            if let scene = try? await Entity(named: "Launch", in: realityKitContentBundle) {
                content.add(scene)
            }
        }
    }
}
