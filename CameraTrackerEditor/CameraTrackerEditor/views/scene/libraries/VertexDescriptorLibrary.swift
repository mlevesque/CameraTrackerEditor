//
//  VertexDescriptorLibrary.swift
//  CameraTrackerEditor
//
//  Created by Michael Levesque on 9/11/19.
//  Copyright © 2019 Michael Levesque. All rights reserved.
//

import MetalKit

/**
 Types of vertex descriptor types.
 */
enum VertexDescriptorType {
    case basic
}

/**
 Library of cached vertex descriptors.
 */
class VertexDescriptorLibrary {
    /** Dictionary of created vertex descriptors. */
    private static var vertexDescriptors: [VertexDescriptorType: VertexDescriptor] = [:]
    
    /**
     This should be called from the Scene Engine to initialize all vertex descriptors.
    */
    public static func initialize() {
        createDefaultVertexDescriptors()
    }
    
    /**
     Creates all vertex descriptors.
    */
    private static func createDefaultVertexDescriptors() {
        vertexDescriptors.updateValue(BasicVertexDescriptor(), forKey: .basic)
    }
    
    /**
     Returns a vertex descriptor for the given type.
     - Parameter type: The Vertex Descriptor type.
     - Returns: The vertex descriptor for the given type.
    */
    public static func descriptor(_ type: VertexDescriptorType) -> MTLVertexDescriptor {
        return vertexDescriptors[type]!.vertexDescriptor
    }
}


/**
 Blueprint for a vertex descriptor object.
 */
fileprivate protocol VertexDescriptor {
    /** The display name for the descriptor. */
    var name: String { get }
    /** The vertex descriptor. */
    var vertexDescriptor: MTLVertexDescriptor { get }
}


/**
 Basic Vertex Descriptor to go with the basic vertex shader.
 */
public struct BasicVertexDescriptor : VertexDescriptor {
    var name: String = "Basic Vertex Descriptor"
    
    var vertexDescriptor: MTLVertexDescriptor {
        let vertexDescriptor = MTLVertexDescriptor()
        
        // position
        vertexDescriptor.attributes[0].format = .float3
        vertexDescriptor.attributes[0].bufferIndex = 0
        vertexDescriptor.attributes[0].offset = 0
        
        // color
        vertexDescriptor.attributes[1].format = .float4
        vertexDescriptor.attributes[1].bufferIndex = 0
        vertexDescriptor.attributes[1].offset = float3.size
        
        vertexDescriptor.layouts[0].stride = Vertex.stride
        
        return vertexDescriptor
    }
}
