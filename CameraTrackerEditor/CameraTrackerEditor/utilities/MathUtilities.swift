//
//  MathUtilities.swift
//  CameraTrackerEditor
//
//  Created by Michael Levesque on 8/11/19.
//  Copyright © 2019 Michael Levesque. All rights reserved.
//

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
