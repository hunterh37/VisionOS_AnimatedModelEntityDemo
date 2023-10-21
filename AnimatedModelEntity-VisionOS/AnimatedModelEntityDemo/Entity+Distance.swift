//
//  Entity+Distance.swift
//  AnimatedModelEntityDemo
//
//  Created by Hunter Harris on 7/22/23.
//

import Foundation
import RealityKit

// Extension to set ground shadow in each child Entity
extension Entity {
    /// Executes a closure for each of the entity's child and descendant
    /// entities, as well as for the entity itself.
    ///
    /// Set `stop` to true in the closure to abort further processing of the child entity subtree.
    func enumerateHierarchy(_ body: (Entity, UnsafeMutablePointer<Bool>) -> Void) {
        var stop = false

        func enumerate(_ body: (Entity, UnsafeMutablePointer<Bool>) -> Void) {
            guard !stop else {
                return
            }
            body(self, &stop)
            
            for child in children {
                guard !stop else {
                    break
                }
                child.enumerateHierarchy(body)
            }
        }
        enumerate(body)
    }
}

extension SIMD3 where Scalar == Float {
    func distance(from other: SIMD3<Float>) -> Float {
        return simd_distance(self, other)
    }

    var printed: String {
        String(format: "(%.8f, %.8f, %.8f)", x, y, z)
    }

    static func spawnPoint(from: SIMD3<Float>, radius: Float) -> SIMD3<Float> {
        from + (radius == 0 ? .zero : SIMD3<Float>.random(in: Float(-radius)..<Float(radius)))
    }

    func angle(other: SIMD3<Float>) -> Float {
        atan2f(other.x - self.x, other.z - self.z) + Float.pi
    }

    var length: Float { return distance(from: .init()) }

    var isNaN: Bool {
        x.isNaN || y.isNaN || z.isNaN
    }

    var normalized: SIMD3<Float> {
        return self / length
    }

    static let up: Self = .init(0, 1, 0)

    func vector(to b: SIMD3<Float>) -> SIMD3<Float> {
        b - self
    }

    var isVertical: Bool {
        dot(self, Self.up) > 0.9
    }
}

extension SIMD2 where Scalar == Float {
    func distance(from other: Self) -> Float {
        return simd_distance(self, other)
    }

    var length: Float { return distance(from: .init()) }
}

extension BoundingBox {

    var volume: Float { extents.x * extents.y * extents.z }
}



extension Entity {
    func distance(from other: Entity) -> Float {
        transform.translation.distance(from: other.transform.translation)
    }
    
    func distance(from point: SIMD3<Float>) -> Float {
        transform.translation.distance(from: point)
    }

    func isDistanceWithinThreshold(from other: Entity, max: Float) -> Bool {
        isDistanceWithinThreshold(from: transform.translation, max: max)
    }

    func isDistanceWithinThreshold(from point: SIMD3<Float>, max: Float) -> Bool {
        transform.translation.distance(from: point) < max
    }
}
