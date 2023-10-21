//
//  AnimationSystem.swift
//  AnimatedModelEntityDemo
//
//  Created by Hunter Harris on 7/22/23.
//

import Foundation
import RealityKit
import GameplayKit

struct AnimationComponent: Component {
    let stateMachine: GKStateMachine
}

class AnimationSystem: System {
    
    private static let query = EntityQuery(where: .has(AnimationComponent.self) && .has(SettingsComponent.self) && .has(MotionComponent.self))
    
    required init(scene: Scene) { }
    
    func update(context: SceneUpdateContext) {
        let animators = context.scene.performQuery(Self.query)
        
        for entity in animators {
            guard let animation = entity.components[AnimationComponent.self],
                  let motion = entity.components[MotionComponent.self] else { continue }
            
            // Update GKStateMachine in Animation component
            updateState(entity: entity, motion: motion, animation: animation)
        }
    }
    
    private func updateState(entity: Entity, motion: MotionComponent, animation: AnimationComponent) {
        // If this Entity has motion, enter Walk state
        if motion.velocity.length > 0 {
            switch animation.stateMachine.currentState {
            case is IdleState:
                animation.stateMachine.enter(WalkingState.self)
            default:
                break
            }
        }
        
        // Only trigger animation change once when leaving state
        if motion.velocity.length == 0 {
            switch animation.stateMachine.currentState {
            case is WalkingState:
                animation.stateMachine.enter(IdleState.self)
            default:
                break
            }
        }
    }
}

