//
//  VertexDescriptorLibrary.swift
//  CameraTrackerEditor
//
//  Created by Michael Levesque on 9/14/19.
//  Copyright © 2019 Michael Levesque. All rights reserved.
//

import MetalKit

/** Types of vertex descriptors. */
enum VertexDescriptorType {
    case basic
}

/**
 Library of all our vertex descriptors.
 */
class VertexDescriptorLibrary: GraphicsLibrary<VertexDescriptorType, MTLVertexDescriptor> {
    /** Dictionary of all vertex descriptors. */
    private var _library: [VertexDescriptorType: VertexDescriptor] = [:]
    
    /**
     Fills dictionary of all our vertex descriptors.
    */
    override func fillLibrary() {
        _library.updateValue(Basic_VertexDescriptor(), forKey: .basic)
    }
    
    /**
     Accessor for vertex descriptors.
     - Parameter type: The type of descriptor to return.
     - Returns: The vertex descriptor.
    */
    override subscript(_ type: VertexDescriptorType) -> MTLVertexDescriptor {
        return _library[type]!.vertexDescriptor
    }
}

/**
 Blueprint for a vertex descriptor to store in the library.
*/
protocol VertexDescriptor {
    var name: String { get }
    var vertexDescriptor: MTLVertexDescriptor! { get }
}

public struct Basic_VertexDescriptor: VertexDescriptor {
    var name: String = "Basic Vertex Descriptor"
    var vertexDescriptor: MTLVertexDescriptor!
    
    init() {
        vertexDescriptor = MTLVertexDescriptor()
        
        //Position
        vertexDescriptor.attributes[0].format = .float3
        vertexDescriptor.attributes[0].bufferIndex = 0
        vertexDescriptor.attributes[0].offset = 0
        
        //Color
        vertexDescriptor.attributes[1].format = .float4
        vertexDescriptor.attributes[1].bufferIndex = 0
        vertexDescriptor.attributes[1].offset = float3.size
        
        //Texture Coordinate
        vertexDescriptor.attributes[2].format = .float2
        vertexDescriptor.attributes[2].bufferIndex = 0
        vertexDescriptor.attributes[2].offset = float3.size + float4.size
        
        //Normal
        vertexDescriptor.attributes[3].format = .float3
        vertexDescriptor.attributes[3].bufferIndex = 0
        vertexDescriptor.attributes[3].offset = float3.size + float4.size + float2.size
        
        vertexDescriptor.layouts[0].stride = Vertex.stride
    }
}
