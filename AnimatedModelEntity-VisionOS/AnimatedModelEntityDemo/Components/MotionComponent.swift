//
//  MotionComponent.swift
//  AnimatedModelEntityDemo
//
//  Created by Hunter Harris on 7/22/23.
//

import RealityKit

struct MotionComponent: Component {
    
    struct Force {
        let acceleration: SIMD3<Float>
        let multiplier: Float
        let name: String
    }

    var forces = [Force]()

    var velocity: SIMD3<Float> = SIMD3<Float>.zero
    var isFlying: Bool = false
}
