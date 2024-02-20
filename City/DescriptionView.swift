//
//  DescriptionView.swift
//  City
//
//  Created by Arun Kulkarni on 20/02/24.
//

import SwiftUI

struct DescriptionWindow: Scene
{
    var body: some Scene {
        WindowGroup(id: "DescriptionWindow") {
            ZStack {
                ZStack {
                    Color.gray.opacity(0.25).ignoresSafeArea()
                    
                    Color.white.opacity(0.7).blur(radius: 200).ignoresSafeArea()
                    GeometryReader{ geometry in
                        let size = geometry.size
                        Circle().fill(.purple)
                            .padding(50)
                            .blur(radius: 120)
                            .offset(x: -size.width/1.8, y: -size.height/5)
                        Circle().fill(.blue)
                            .padding(50)
                            .blur(radius: 150)
                            .offset(x: -size.width/1.8, y: -size.height/2)
                    }
                    RoundedRectangle(cornerRadius: 20.0)
                        .fill(.white)
                        .opacity(0.25)
                        .shadow(radius: 10.0)
                        .padding()
                }

                VStack {
                    DescriptionView()
                }.padding(100)
            }
            
        }.windowStyle(.volumetric).defaultSize(width: 0.01, height: 0.01, depth: 0.0, in: .meters)
    }
}

struct DescriptionView: View {
    @Environment(\.openImmersiveSpace) private var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) private var dismissImmersiveSpace

    @Environment(\.openWindow) private var openWindow
    @Environment(\.dismissWindow) private var dismissWindow

    var body: some View {
        
        Button("Back"){
                Task {
                    await dismissImmersiveSpace()
                    await openImmersiveSpace(id: "LaunchSpace")
                    dismissWindow(id: "DescriptionWindow")
                    openWindow(id: "ContentView")
                }
        }.onTapGesture {
            Task {
                await dismissImmersiveSpace()
                await openImmersiveSpace(id: "LaunchSpace")
                dismissWindow(id: "DescriptionWindow")
                openWindow(id: "ContentView")
            }
        }
    }
}

#Preview {
    DescriptionView()
}
