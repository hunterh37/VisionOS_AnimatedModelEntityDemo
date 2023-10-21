//
//  AnimatedModelEntityDemoApp.swift
//  AnimatedModelEntityDemo
//
//  Created by Hunter Harris on 10/5/23.
//

import SwiftUI


//
// Simple app using Entity Component System (ECS) to showcase,
// playing multiple animations on a single ModelEntity loaded from .usdz
//
// Note: Each animation must be loaded from individually from .usdz
// so you must create a .usdz file for each animation
//
// Animation state set in AnimationSystem
// Movement forces applied in MotionSystem
// Wandering movement set in WanderSystem
//

@main
struct AnimatedModelEntityDemo: App {
    @State private var viewModel = ViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }.defaultSize(width: 500, height: 200)
        
        ImmersiveSpace(id: "Space") {
            ImmersiveView(viewModel: viewModel)
        }.immersionStyle(selection: $viewModel.immersionStyle, in: .full, .mixed)
    }
    
    // Register all RealityKit Systems & Components
    init() {
        MotionSystem.registerSystem()
        WanderSystem.registerSystem()
        AnimationSystem.registerSystem()
        AnimationSpeedSystem.registerSystem()
        
        AnimationComponent.registerComponent()
        SettingsComponent.registerComponent()
        MotionComponent.registerComponent()
        WanderAimlesslyComponent.registerComponent()
        AnimationSpeedComponent.registerComponent()
    }
}
