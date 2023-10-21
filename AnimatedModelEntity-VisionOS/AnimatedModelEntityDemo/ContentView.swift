//
//  ContentView.swift
//  AnimatedModelEntityDemo
//
//  Created by Hunter Harris on 10/5/23.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ContentView: View {
    @State var showImmersiveSpace = false
    @State var spaceActive = false
    
    @Environment(\.openImmersiveSpace) var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) var dismissImmersiveSpace
    
    var body: some View {
        VStack {
            Text("Animated ModelEntity Demo")
            
            Button(action: {
                if spaceActive {
                    Task {
                        spaceActive = false
                        await dismissImmersiveSpace()
                    }
                } else {
                    Task {
                        spaceActive = true
                        await openImmersiveSpace(id: "Space")
                    }
                }
            }, label: {
                Text(spaceActive ? "Exit" : "Enter").font(.largeTitle).frame(width: 100, height: 100)
            })
        }.padding(50)
    }
}

#Preview {
    ContentView()
}
