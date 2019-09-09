//
//  FloorPrimitive.swift
//  CameraTrackerEditor
//
//  Created by Michael Levesque on 9/8/19.
//  Copyright © 2019 Michael Levesque. All rights reserved.
//

import MetalKit

class FloorPrimitive {
    private let _size: vector_float3
    private let _segments: vector_uint2
    
    init( width: Float,
          depth: Float,
          widthSegments: UInt32,
          depthSegments: UInt32) {
        _size = [width, 1, depth]
        _segments = [widthSegments, depthSegments]
    }
    
    func make(device: MTLDevice) -> MDLMesh {
        let allocator = MTKMeshBufferAllocator(device: device)
        return MDLMesh(
            planeWithExtent: _size,
            segments: _segments,
            geometryType: .triangles,
            allocator: allocator
        )
    }
}
