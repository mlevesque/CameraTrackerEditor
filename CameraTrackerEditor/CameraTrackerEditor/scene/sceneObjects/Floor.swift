//
//  Floor.swift
//  CameraTrackerEditor
//
//  Created by Michael Levesque on 9/14/19.
//  Copyright © 2019 Michael Levesque. All rights reserved.
//

import MetalKit

class FloorPrimitive : Node {
    private let _size: float2
    private let _segments: uint2
    
    init( width: Float,
          depth: Float,
          widthSegments: UInt32,
          depthSegments: UInt32) {
        _size = float2(width, depth)
        _segments = uint2(widthSegments, depthSegments)
    }
    
//    func make(device: MTLDevice) -> MDLMesh {
//        let allocator = MTKMeshBufferAllocator(device: device)
//        return MDLMesh(
//            planeWithExtent: _size,
//            segments: _segments,
//            geometryType: .triangles,
//            allocator: allocator
//        )
//    }
}
