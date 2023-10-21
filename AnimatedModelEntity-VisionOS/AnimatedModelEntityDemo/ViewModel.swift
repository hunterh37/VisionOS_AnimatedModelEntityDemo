//
//  ViewModel.swift
//  AnimatedModelEntityDemo
//
//  Created by Hunter Harris on 10/6/23.
//

import SwiftUI
import RealityKit
import ARKit
import GameplayKit

let rootEntity = Entity()
var floorEntity = ModelEntity()
var diverEntity = ModelEntity()

class ViewModel: ObservableObject {
    @Published var immersionStyle: ImmersionStyle = .mixed
    @Published var models: [Entity] = [Entity]()
    
    var diver_walkAnim: AnimationResource?
    var diver_idleAnim: AnimationResource?
}

extension ViewModel {
    
    @MainActor
    func loadDiverAnims() async {
        if let entity = try? await ModelEntity(named: "Diver/diver_anim_walk") {
            diver_walkAnim = entity.availableAnimations.first
        }
        if let entity2 = try? await ModelEntity(named: "Diver/diver_anim_stand_idle") {
            diver_idleAnim = entity2.availableAnimations.first
        }
    }
    
    @MainActor
    
    /// Loads the Diver from .usdz, configures each system component, and adds it to the rootEntity of the scene
    ///
    /// Wandering movement controlled in WanderSystem
    /// Movement forces applied in MotionSystem
    /// Animation state controlled in AnimationSystem
    func loadDiver() async {
        await loadDiverAnims()
        
        // Load the Diver from .usdz file
        if let entity = try? await ModelEntity(named: "Diver/diver_anim_stand_idle") {
            let settings: Settings = CreatureSettings.monkeySettings
            entity.components[SettingsComponent.self] = SettingsComponent(settings: settings)
            
            // Configure AnimationSpeedComponent, adjust the animation speed based on the velocity.
            if let anim = entity.availableAnimations.first {
                let animationController = entity.playAnimation(anim.repeat())
                let animSpeedComponent = AnimationSpeedComponent(animationController: animationController)
                entity.components[AnimationSpeedComponent.self] = animSpeedComponent
            }
            
            // Set the Wondering Component
            entity.components[MotionComponent.self] = MotionComponent()
            var wanderComponent = WanderAimlesslyComponent()
            wanderComponent.wanderRangeMax = settings.wanderRadius
            entity.components[WanderAimlesslyComponent.self] = WanderAimlesslyComponent()
            
            // Configure State Machine
            if let diver_walkAnim, let diver_idleAnim {
                let stateMachine = GKStateMachine(states: [
                    IdleState(anim: diver_idleAnim,
                              options: CharacterStateOptions(),
                              animationRoot: entity),
                    WalkingState(anim: diver_walkAnim,
                                 options: CharacterStateOptions(),
                                 animationRoot: entity)
                ])
                
                entity.components[AnimationComponent.self] = AnimationComponent(stateMachine: stateMachine)
                stateMachine.enter(IdleState.self)
            }
            
            models.append(entity)
            diverEntity = entity
            rootEntity.addChild(diverEntity)
        }
    }
    
    func spawnFloor() {
        let material = UnlitMaterial(color: .clear)
        floorEntity = ModelEntity(mesh: .generateBox(width: 30, height: 1, depth: 20), materials: [material], collisionShape: .generateBox(width: 30, height: 1, depth: 20), mass: 100000)
        floorEntity.components[PhysicsBodyComponent.self] = .init(massProperties: .init(mass: 100000), material: .default,  mode: .static)
        floorEntity.position = .init(x: 0, y: -0.5, z: 0)
        rootEntity.addChild(floorEntity)
    }
}
