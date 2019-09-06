//
//  Primitive.swift
//  CameraTrackerEditor
//
//  Created by Michael Levesque on 9/5/19.
//  Copyright © 2019 Michael Levesque. All rights reserved.
//

import MetalKit

class Primitive {
    class func makeCube(device: MTLDevice, size: Float) -> MDLMesh {
        let allocator = MTKMeshBufferAllocator(device: device)
        let mesh = MDLMesh(boxWithExtent: [size, size, size],
                           segments: [1, 1, 1],
                           inwardNormals: false, geometryType: .triangles,
                           allocator: allocator)
        return mesh
    }
}
