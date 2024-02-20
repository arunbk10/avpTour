//
//  WelcomeView.swift
//  City
//
//  Created by Arun Kulkarni on 19/02/24.
//

import SwiftUI

struct WelcomeView: View {
    @Environment(ViewModel.self) private var model

    @Environment(\.openImmersiveSpace) private var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) private var dismissImmersiveSpace
    
    @Environment(\.openWindow) private var openWindow
    @Environment(\.dismissWindow) private var dismissWindow

    @State private var isSpaceHidden: Bool = true
    
    var body: some View {
        @Bindable var model = model

        NavigationStack {
            VStack {
                Spacer()
                Image("BgLogo")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 350, height: 350)
                    .clipShape(Circle())
                    .padding(.top, 20)
                
                Spacer()
                
                VStack {
                    Text(model.finalTitle)
                        .font(.system(size: 50, weight: .bold))
                        .opacity(0.0) // Initially hidden, it'll be animated later
                        .overlay(
                            Text(model.titleText)
                                .font(.system(size: 40, weight: .bold))
                                .padding(.leading, 40)
                        )
                }
                .padding()
                
                Button(action: {
                    Task {
                        if isSpaceHidden {
                            model.isChatView = true
                            await dismissImmersiveSpace()
                            await openImmersiveSpace(id: "ImmersiveSpace")
                            isSpaceHidden = false
                            dismissWindow(id: "LaunchWindow")
                            openWindow(id: "ChatView")
                        } else {
                            await dismissImmersiveSpace()
                            isSpaceHidden = true
                        }
                    }
                }) {
                    Text("Ask me").font(.system(size: 60))
                        .frame(width: 300 , height: 80, alignment: .center)
                }.foregroundStyle(.white).glassBackgroundEffect()
                    .controlSize(.extraLarge)
                Spacer()

            }
            .typeText(
                text: $model.titleText,
                finalText: model.finalTitle,
                isFinished: $model.isTitleFinished,
                isAnimated: !model.isTitleFinished
            )
        }
    }
}

#Preview {
    WelcomeView().environment(ViewModel())
}
