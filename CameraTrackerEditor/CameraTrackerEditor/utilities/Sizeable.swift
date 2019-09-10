//
//  Sizeable.swift
//  CameraTrackerEditor
//
//  Created by Michael Levesque on 9/9/19.
//  Copyright © 2019 Michael Levesque. All rights reserved.
//

import simd

protocol Sizeable {}
extension Sizeable {
    static var size: Int {
        return MemoryLayout<Self>.size
    }
    
    static var stride: Int {
        return MemoryLayout<Self>.stride
    }
    
    static func size(_ count: Int) -> Int {
        return size * count
    }
    
    static func stride(_ count: Int) -> Int {
        return stride * count
    }
}

extension float3 : Sizeable {}
extension float4 : Sizeable {}
