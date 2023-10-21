//
//  AnimationSpeedComponent.swift
//  AnimatedModelEntityDemo
//
//  Created by Hunter Harris on 7/22/23.
//

import Foundation
import RealityKit

struct AnimationSpeedComponent: RealityKit.Component {
    var animationController: AnimationPlaybackController
}

class AnimationSpeedSystem: RealityKit.System {

    private static let query = EntityQuery(where: .has(AnimationSpeedComponent.self) && .has(MotionComponent.self))

    required init(scene: Scene) { }

    static var dependencies: [SystemDependency] { [.after(MotionSystem.self)] }

    func update(context: SceneUpdateContext) {

        let animators = context.scene.performQuery(Self.query)

        for animator in animators {
            guard let animSpeedComponent = animator.components[AnimationSpeedComponent.self],
                  let motion = animator.components[MotionComponent.self],
                  let animation = animator.components[AnimationComponent.self],
                  let settings = (animator.components[SettingsComponent.self])?.settings else { continue }

            let animationController = animSpeedComponent.animationController

            guard animation.stateMachine.currentState is WalkingState else {
                animationController.speed = 1
                return
            }

            // Make the animation play faster when the fish is swimming fast,
            // slower when it's swimming slowly.
            var animationFramerate = motion.velocity.length
            animationFramerate *= settings.animationScalar
            animationController.speed = animationFramerate
        }
    }
}
