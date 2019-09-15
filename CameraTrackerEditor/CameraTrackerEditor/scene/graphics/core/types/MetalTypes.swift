//
//  MetalTypes
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

extension Int32: Sizeable {}
extension float2 : Sizeable {}
extension float3 : Sizeable {}
extension float4 : Sizeable {}

struct Vertex: Sizeable{
    var position: float3
    var color: float4
    var textureCoordinate: float2
    var normal: float3
}

struct ModelConstants: Sizeable{
    var modelMatrix = matrix_identity_float4x4
}

struct SceneConstants: Sizeable {
    var totalGameTime: Float = 0
    var viewMatrix = matrix_identity_float4x4
    var projectionMatrix = matrix_identity_float4x4
}

struct Material: Sizeable {
    var color = float4(0.8, 0.8, 0.8, 1.0)
    var useMaterialColor: Bool = false
    var useTexture: Bool = false
    var isLit: Bool = true
    
    var ambient: float3 = float3(0.1, 0.1, 0.1)
    var diffuse: float3 = float3(1,1,1)
}

struct LightData: Sizeable {
    var position: float3 = float3(0,0,0)
    var color: float3 = float3(1,1,1)
    var brightness: Float = 1.0
    
    var ambientIntensity: Float = 1.0
    var diffuseIntensity: Float = 1.0
}
