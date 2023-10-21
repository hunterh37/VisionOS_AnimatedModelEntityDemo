//
//  SettingsComponent.swift
//  AnimatedModelEntityDemo
//
//  Created by Hunter Harris on 7/22/23.
//

import RealityKit
import Combine
import Foundation
import SwiftUI

class Settings: ObservableObject {
    @Published var topSpeed: Float = 0.018
    @Published var maxSteeringForce: Float = 5.0
    @Published var animationScalar: Float = 400.0
    @Published var timeScale: Float = 1.0
    
    /// Speed of the rotation of the model, independent of physics/movement.
    @Published var angularModelSpeed: Float = 1E+3
    @Published var useAngularModelSpeed: Bool = false

    var wanderOrigin = SIMD3<Float>(0, 0.2, 0)
    var wanderRadius: Float = 10.7

    var maxSteeringForceVector: SIMD3<Float> {
        SIMD3<Float>(repeating: maxSteeringForce)
    }

    var topSpeedVector: SIMD3<Float> {
        SIMD3<Float>(repeating: topSpeed)
    }
}


struct SettingsComponent: Component {
    var settings: Settings
}


class CreatureSettings {
    static var monkeySettings: Settings {
        let settings = Settings()
        settings.topSpeed = 0.2
        settings.wanderRadius = 2
        settings.animationScalar = 2
        return settings
    }
}
