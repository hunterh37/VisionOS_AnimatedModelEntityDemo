//
//  AnimStates.swift
//  AnimatedModelEntityDemo
//
//  Created by Hunter Harris on 7/22/23.
//

import Foundation
import RealityKit
import Combine
import GameplayKit

struct CharacterStateOptions {
    var jumpSpeed: Float = 1.5
    var walkingSpeed: Float = 3.5
    var transitionDuration: Float = 1.0
    var angularSpeed: Float = 100.0
    var resetTransform: Bool = false
}

class CharacterState: GKState {
    let animationRoot: Entity
    let animationResource: AnimationResource
    let options: CharacterStateOptions
    var animationCancellable: Cancellable?
    var animController: AnimationPlaybackController?

    init(anim: AnimationResource, options: CharacterStateOptions, animationRoot: Entity) {
        self.options = options
        self.animationResource = anim
        self.animationRoot = animationRoot
    }
}

class IdleState: CharacterState {
    override func didEnter(from previousState: GKState?) {
        var transitionDuration: Float = 0

        if previousState is WalkingState {
            transitionDuration = options.transitionDuration
        }
        
        animController = animationRoot.playAnimation(
            animationResource.repeat(),
            transitionDuration: TimeInterval(transitionDuration))
    }
}

class WalkingState: CharacterState {
    override func didEnter(from previousState: GKState?) {
        animController = animationRoot.playAnimation(
            animationResource.repeat(),
            transitionDuration: TimeInterval(options.transitionDuration)
        )
    }
}

