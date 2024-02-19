/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
A view, used as an attachment, that gives information about a point of interest.
*/

import SwiftUI
import RealityKit
import RealityKitContent
import MapKit

public struct LearnMoreView: View {

    @Environment(\.openImmersiveSpace) var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) var dismissImmersiveSpace
    @State private var showImmersiveSpace = false

    let name: String
    let description: String
    let id: PlaceInfo?
    var viewModel: ViewModel

    @State private var showingMoreInfo = false
    @Namespace private var animation
        
    private var titleFont: Font {
        .system(size: 48, weight: .semibold)
    }
    
    private var descriptionFont: Font {
        .system(size: 36, weight: .regular)
    }
    
    public var body: some View {
        VStack {
            Spacer()
            ZStack(alignment: .center) {
                if !showingMoreInfo {
                    Text(name)
                        .matchedGeometryEffect(id: "Name", in: animation)
                        .font(titleFont)
                        .padding()
                }
                
                if showingMoreInfo {
                    VStack(alignment: .leading, spacing: 10) {
                        Text(name)
                            .matchedGeometryEffect(id: "Name", in: animation)
                            .font(titleFont)
                        
                        Text(description)
                            .font(descriptionFont)
                        
                    }
                }
            }
            .frame(width: 408)
            .padding(24)
            .redBackground()
            .onTapGesture {
                withAnimation(.spring) {
                    showingMoreInfo.toggle()
                    if let place = id
                    {
                        viewModel.updateScale()
                        viewModel.selectedPlaceInfo = place
                        Task {
                            try? await viewModel.setSnapshot()
                        }
                        self.showImmersiveSpace  = true
                    }
                }
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

public extension View {
    func redBackground() -> some View {
        modifier(RedBackground())
    }
}

public struct RedBackground: ViewModifier {
    public func body(content: Content) -> some View {
        content
            .background(.red.opacity(0.2))
            .glassBackgroundEffect(in: .rect(cornerRadius: 10))
    }
}

#Preview {
    RealityView { content, attachments in
        if let entity = attachments.entity(for: "z") {
            content.add(entity)
        }
    } attachments: {
        Attachment(id: "z") {
            LearnMoreView(name: "Phoenix Lake",
                          description: "Lake · Northern California",
                          
                          id: PlaceInfo(name: "Phoenix Lake", locationCoordinate: CLLocationCoordinate2DMake(40.758896, -73.985130), panoId: ""),
                          viewModel: ViewModel())
        }
    }
}
