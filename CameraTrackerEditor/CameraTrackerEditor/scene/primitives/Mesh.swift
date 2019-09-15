//
//  Mesh.swift
//  CameraTrackerEditor
//
//  Created by Michael Levesque on 9/12/19.
//  Copyright © 2019 Michael Levesque. All rights reserved.
//

import MetalKit

/**
 Blueprint of a mesh.
 */
protocol Mesh {
    var vertexBuffer: MTLBuffer! { get }
    var vertexCount: Int! { get }
}

/**
 Base class of a custom mesh. This should be subclassed.
 */
class CustomMesh : Mesh {
    var color: float4
    internal var vertices: [Vertex]!
    internal var vertexBuffer: MTLBuffer!
    
    var vertexCount: Int! {
        return vertices.count
    }
    
    init(color: float4 = float4(1, 1, 1, 1)) {
        self.color = color
        createVertices()
        createBuffers()
    }
    
    func createVertices() {}
    
    func createBuffers() {
        vertexBuffer = SceneEngine.device.makeBuffer(
            bytes: vertices,
            length: Vertex.stride(vertices.count),
            options: []
        )
    }
}

/**
 Custom mesh for a single triangle.
 */
class TrianglesMesh : CustomMesh {
    override func createVertices() {
        vertices = [
            Vertex(position:float3( 0, 1, 0),color:float4(1,0,0,1),textureCoord:float2(0,0),normal:float3(0,0,1)),
            Vertex(position:float3(-1,-1, 0),color:float4(0,1,0,1),textureCoord:float2(1,0),normal:float3(0,0,1)),
            Vertex(position:float3( 1,-1, 0),color:float4(0,0,1,1),textureCoord:float2(0,1),normal:float3(0,0,1))
        ]
    }
}

class CubeMesh : CustomMesh {
    private var _width: Float
    private var _height: Float
    private var _length: Float
    
    init(width: Float = 1, height: Float = 1, length: Float = 1) {
        _width = width
        _height = height
        _length = length
        super.init()
    }
    
    public var width: Float {
        get { return _width }
        set(value) {
            _width = value
            createVertices()
            createBuffers()
        }
    }
    
    public var height: Float {
        get { return _height }
        set(value) {
            _height = value
            createVertices()
            createBuffers()
        }
    }
    
    public var length: Float {
        get { return _length }
        set(value) {
            _length = value
            createVertices()
            createBuffers()
        }
    }
    
    override func createVertices() {
//        vertices = [
//            Vertex(position: float3( width, height, length), color: color),
//            Vertex(position: float3(), color: <#T##float4#>)
//        ]
    }
}
