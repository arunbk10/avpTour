//
//  ImmersiveView.swift
//  City
//
//  Created by Arun Kulkarni on 16/02/24.
//

import SwiftUI
import RealityKit
import RealityKitContent
import Combine

struct ImmersiveView: View {
    
    var viewModel: ViewModel

    var body: some View {
        
        if viewModel.isChatView
        {
            RealityView { content in
                content.add(viewModel.setupContentEntity())
            }
        }
        else
        {
            DescriptionView()
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
            content.add(viewModel.setupContentEntity())
        }
    }
}

struct StreetImmersiveView: View {
    
    var viewModel: ViewModel

    var body: some View {
        RealityView { content in
            content.add(viewModel.setupContentEntity())
        }
        .task {
            try? await viewModel.setSnapshot()
        }
    }
}
