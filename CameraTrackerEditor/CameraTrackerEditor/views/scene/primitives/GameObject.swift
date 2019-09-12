//
//  GameObject.swift
//  CameraTrackerEditor
//
//  Created by Michael Levesque on 9/11/19.
//  Copyright © 2019 Michael Levesque. All rights reserved.
//

import MetalKit

class GameObject {
    var vertices: [Vertex]!
    var vertexBuffer: MTLBuffer!
    
    init() {
        createVertices()
        createBuffers()
    }
    
    func createVertices() {
        vertices = [
            Vertex(position: float3( 0, 1, 0), color: float4(1,0,0,1)),
            Vertex(position: float3(-1,-1, 0), color: float4(0,1,0,1)),
            Vertex(position: float3( 1,-1, 0), color: float4(0,0,1,1))
        ]
    }
    
    func createBuffers() {
        vertexBuffer = SceneEngine.device.makeBuffer(
            bytes: vertices,
            length: Vertex.stride * vertices.count,
            options: []
        )
    }
    
    func render(_ commandEncoder: MTLRenderCommandEncoder) {
        commandEncoder.setRenderPipelineState(RenderPipelineStateLibrary.pipelineState(.basic))
        commandEncoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        commandEncoder.drawPrimitives(
            type: .triangle,
            vertexStart: 0,
            vertexCount: vertices.count
        )
    }
}
