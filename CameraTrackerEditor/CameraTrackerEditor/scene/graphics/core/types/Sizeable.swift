//
//  Sizeable.swift
//  CameraTrackerEditor
//
//  Created by Michael Levesque on 9/9/19.
//  Copyright © 2019 Michael Levesque. All rights reserved.
//

import simd

/**
 Sizeable is a helper protocol and extension for various types that will be fed to the GPU and allow us to more easily
 pull the data sizes from them instead of writing the more lengthy MemoryLayout code to get that information.
 */
protocol Sizeable {}
extension Sizeable {
    /** The Memory Layout size of the type. */
    static var size: Int {
        return MemoryLayout<Self>.size
    }
    
    /** The Memory Layout stride of the type. */
    static var stride: Int {
        return MemoryLayout<Self>.stride
    }
    
    /**
     Returns the size of the type multiplied by the given count. Meant for getting the size of an array of that type.
     - Parameter count: Multiplier.
     - Returns: The full size of the type multiplied by count.
    */
    static func size(_ count: Int) -> Int {
        return size * count
    }
    
    /**
     Returns the stride of the type multiplied by the given count. Meant for getting the stride of an array of that
     type.
     - Parameter count: Multiplier.
     - Returns: The full stride of the type multiplied by count.
     */
    static func stride(_ count: Int) -> Int {
        return stride * count
    }
}

extension float2 : Sizeable {}
extension float3 : Sizeable {}
extension float4 : Sizeable {}
