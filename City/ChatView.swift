//
//  ChatView.swift
//  City
//
//  Created by Arun Kulkarni on 19/02/24.
//

import SwiftUI

struct ChatMessage: Identifiable  {
    var id: UUID
    let text: String
    let isUser: Bool
}

struct ChatView: View {
    var viewModel: ViewModel
    @Environment(\.openImmersiveSpace) var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) var dismissImmersiveSpace
    @Environment(\.openWindow) private var openWindow
    @Environment(\.dismissWindow) private var dismissWindow

    /// Chat bot content
    var response: [ChatMessage] = [.init(id: UUID(),text: "Hello! How can I assist you today?", isUser: false),.init(id: UUID(),text: "Please provide me with an itinerary for New York City for a day", isUser: true),.init(id: UUID(), text: "Here's a concise one-day itinerary for New York City:\n1. Morning: Explore Empire state building.\n2.Late Afternoon: Experience Times Square's vibrant energy", isUser: false)
    ,.init(id: UUID(), text: "Thank you, can you show me a glimpse of how it looks?", isUser: true)]
    @State var messages: [ChatMessage] = []
    @State var string: String = ""
    @State var showYesNoButtons = false
    @State var currentIndex = 0
    /// ---
    var body: some View {
        NavigationStack {
            
            VStack{
                
            } .navigationTitle("Wanderlust GENIE")
                .clipShape(.rect)
                .font(.extraLargeTitle2)
        }.frame(height:100)
                .clipShape(.rect(cornerRadius: 0))
                .font(.extraLargeTitle2)
        VStack{
        VStack {
            ScrollView {
                ForEach(messages) { message in
                    Divider()
                    MessageView(message: message)
                }
            }
        }.background(.gray)
        Divider()
        }.background(Color.gray)
        .clipShape(.rect(cornerRadius: 25.0))
        HStack {
            TextField("Message", text: self.$string, axis: .vertical)
                .font(.extraLargeTitle2)
            Button {
                if currentIndex < response.count{
                    messages.append(response[currentIndex])
                    currentIndex += 1
                }
                else {
                    showYesNoButtons = true
                }
            } label: {
                Image(systemName: "paperplane")
                    .font(.extraLargeTitle2)
            }
        }.padding()
            .background(Color(UIColor.darkGray))
            .frame(height:100)
        if showYesNoButtons {
            HStack {
                Button("Yes") {
                    dismissWindow(id: "ChatView")
                    Task {
                        await dismissImmersiveSpace()
                        await openImmersiveSpace(id: "LaunchSpace")
                    }
                    openWindow(id: "ContentView")
                }
                .padding()
                .background(Color.gray)
                .foregroundColor(.white)
                .cornerRadius(10)
                .font(.extraLargeTitle2)
                
                Button("No") {
                    openWindow(id: "LaunchWindow")
                    dismissWindow(id: "ChatView")
                }
                .padding()
                .background(Color(UIColor.lightGray))
                .foregroundColor(.white)
                .cornerRadius(10)
                .font(.extraLargeTitle2)
            }
        }
    }
}

struct MessageView :View{
    var message: ChatMessage
    var body: some View{
        Group{
            
            if message.isUser {
                HStack {
                    
                    Spacer()
                    Text(message.text)
                        .padding(50)                  
                        .background(Color.blue)
                        .foregroundColor(Color.white)
                        .font(.extraLargeTitle2)
                        .clipShape(.capsule)
                        .multilineTextAlignment(.leading)
                    
                }.padding(.trailing,25)
                
            }  else {
                HStack {
                    
                    Text(message.text)
                        .padding(50)
                        .background(Color.green)
                        .foregroundColor(Color.white)
                        .font(.extraLargeTitle2)
                        .clipShape(.capsule)
                        .multilineTextAlignment(.leading)
                    
                    Spacer()
                }.padding(.leading,25)
            }
        }
    }
}

#Preview {
    ChatView(viewModel: ViewModel())
}
