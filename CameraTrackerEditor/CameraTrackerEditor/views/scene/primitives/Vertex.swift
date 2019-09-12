//
//  Vertex.swift
//  CameraTrackerEditor
//
//  Created by Michael Levesque on 9/9/19.
//  Copyright © 2019 Michael Levesque. All rights reserved.
//

import simd

/**
 Defines a vertex to be fed to the vertex shader.
 */
struct Vertex : Sizeable {
    var position: float3
    var color: float4
}
