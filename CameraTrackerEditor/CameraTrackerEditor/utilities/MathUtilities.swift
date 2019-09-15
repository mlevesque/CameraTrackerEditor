//
//  MathUtilities.swift
//  CameraTrackerEditor
//
//  Created by Michael Levesque on 8/11/19.
//  Copyright © 2019 Michael Levesque. All rights reserved.
//

import simd

typealias Vec3 = (x: Float, y: Float, z: Float)


func min(_ a: Vec3, _ b: Vec3) -> Vec3 {
    return (
        x: min(a.x, b.x),
        y: min(a.y, b.y),
        z: min(a.z, b.z)
    )
}

func max(_ a: Vec3, _ b: Vec3) -> Vec3 {
    return (
        x: max(a.x, b.x),
        y: max(a.y, b.y),
        z: max(a.z, b.z)
    )
}


func nearestNeighborInterpolation(a: Float, b: Float, t: Float) -> Float {
    if t < 0.5 {return a}
    else {return b}
}

func nearestNeighborInterpolation(a: Vec3, b: Vec3, t: Float) -> Vec3 {
    return (
        x: nearestNeighborInterpolation(a: a.x, b: b.x, t: t),
        y: nearestNeighborInterpolation(a: a.y, b: b.y, t: t),
        z: nearestNeighborInterpolation(a: a.z, b: b.z, t: t)
    )
}


func linearInterpolation(a: Float, b: Float, t: Float) -> Float {
    return a + (b - a) * t
}

func linearInterpolation(a: Vec3, b: Vec3, t: Float) -> Vec3 {
    return (
        x: linearInterpolation(a: a.x, b: b.x, t: t),
        y: linearInterpolation(a: a.y, b: b.y, t: t),
        z: linearInterpolation(a: a.z, b: b.z, t: t)
    )
}


func cubicInterpolation(p: (Float, Float, Float, Float), t: Float) -> Float {
    return  p.1 + 0.5 * t * (p.2 - p.0 +
                t * (2.0 * p.0 - 5.0 * p.1 + 4.0 * p.2 - p.3 +
                    t * (3.0 * (p.1 - p.2) + p.3 - p.0)))
}

func cubicInterpolation(p: (Vec3, Vec3, Vec3, Vec3), t: Float) -> Vec3 {
    return (
        x: cubicInterpolation(p: (p.0.x, p.1.x, p.2.x, p.3.x), t: t),
        y: cubicInterpolation(p: (p.0.y, p.1.y, p.2.y, p.3.y), t: t),
        z: cubicInterpolation(p: (p.0.z, p.1.z, p.2.z, p.3.z), t: t)
    )
}


public var X_AXIS: float3 {
    return float3(1,0,0)
}

public var Y_AXIS: float3 {
    return float3(0,1,0)
}

public var Z_AXIS: float3 {
    return float3(0,0,1)
}


extension Float {
    var toRadians: Float {
        return (self / 180.0) * Float.pi
    }
    
    var toDegrees: Float {
        return self * (180.0 / Float.pi)
    }
    
    static var randomZeroToOne: Float {
        return Float(arc4random()) / Float(UINT32_MAX)
    }
}


extension matrix_float4x4 {
    mutating func translate(direction: float3) {
        var result = matrix_identity_float4x4
        
        let x: Float = direction.x
        let y: Float = direction.y
        let z: Float = direction.z
        
        result.columns = (
            float4(1,0,0,0),
            float4(0,1,0,0),
            float4(0,0,1,0),
            float4(x,y,z,1)
        )
        
        self = matrix_multiply(self, result)
    }
    
    mutating func scale(axis: float3) {
        var result = matrix_identity_float4x4
        
        let x: Float = axis.x
        let y: Float = axis.y
        let z: Float = axis.z
        
        result.columns = (
            float4(x,0,0,0),
            float4(0,y,0,0),
            float4(0,0,z,0),
            float4(0,0,0,1)
        )
        
        self = matrix_multiply(self, result)
    }
    
    
    mutating func rotate(angle: Float, axis: float3) {
        var result = matrix_identity_float4x4
        
        let x: Float = axis.x
        let y: Float = axis.y
        let z: Float = axis.z
        
        let c: Float = cos(angle)
        let s: Float = sin(angle)
        
        let mc: Float = (1 - c)
        
        let r1c1: Float = x * x * mc + c
        let r2c1: Float = x * y * mc + z * s
        let r3c1: Float = x * z * mc - y * s
        let r4c1: Float = 0.0
        
        let r1c2: Float = y * x * mc - z * s
        let r2c2: Float = y * y * mc + c
        let r3c2: Float = y * z * mc + x * s
        let r4c2: Float = 0.0
        
        let r1c3: Float = z * x * mc + y * s
        let r2c3: Float = z * y * mc - x * s
        let r3c3: Float = z * z * mc + c
        let r4c3: Float = 0.0
        
        let r1c4: Float = 0.0
        let r2c4: Float = 0.0
        let r3c4: Float = 0.0
        let r4c4: Float = 1.0
        
        result.columns = (
            float4(r1c1, r2c1, r3c1, r4c1),
            float4(r1c2, r2c2, r3c2, r4c2),
            float4(r1c3, r2c3, r3c3, r4c3),
            float4(r1c4, r2c4, r3c4, r4c4)
        )
        
        self = matrix_multiply(self, result)
    }
}
