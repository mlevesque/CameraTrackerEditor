//
//  RenderPipelineDescriptorLibrary.swift
//  CameraTrackerEditor
//
//  Created by Michael Levesque on 9/11/19.
//  Copyright © 2019 Michael Levesque. All rights reserved.
//

import MetalKit

/**
 Types of Render Pipeline Descriptors used as dictionary keys.
 */
enum RenderPipelineDescriptorType {
    case basic
}

/**
 Library for looking up Render Pipeline Descriptors.
 */
class RenderPipelineDescriptorLibrary {
    /** Dictionary of Render Pipeline Descriptors. */
    private static var renderPipelineDescriptors: [RenderPipelineDescriptorType: RenderPipelineDescriptor] = [:]
    
    /**
     Should be called from the Scene Engine to initialize Render Pipeline Descriptors.
    */
    public static func initialize() {
        createDefaultRenderPipelineDescriptors()
    }
    
    /**
     Creates all Render Pipeline Descriptors.
    */
    private static func createDefaultRenderPipelineDescriptors() {
        renderPipelineDescriptors.updateValue(BasicRenderPipelineDescriptor(), forKey: .basic)
    }
    
    /**
     Returns a Render Pipeline Descriptor for the given type.
     - Parameter type: The type of Render Pipeline Descriptor to return.
     - Returns: The Render Pipeline Descriptor for the given type.
    */
    public static func descriptor(_ type: RenderPipelineDescriptorType) -> MTLRenderPipelineDescriptor {
        return renderPipelineDescriptors[type]!.renderPipelineDescriptor
    }
}


/**
 Blueprint for a Render Pipeline Descriptor.
 */
protocol RenderPipelineDescriptor {
    /** Display name for the descriptor. */
    var name: String { get }
    /** The Render Pipeline Descriptor. */
    var renderPipelineDescriptor: MTLRenderPipelineDescriptor { get }
}


/**
 The basic Render Pipeline Descriptor.
 */
struct BasicRenderPipelineDescriptor : RenderPipelineDescriptor {
    var name: String = "Basic Render Pipeline Descriptor"
    
    var renderPipelineDescriptor: MTLRenderPipelineDescriptor {
        let renderPipelineDescriptor = MTLRenderPipelineDescriptor()
        
        renderPipelineDescriptor.colorAttachments[0].pixelFormat = RenderPreferences.pixelFormat
        renderPipelineDescriptor.vertexFunction = ShaderLibrary.vertex(.basic)
        renderPipelineDescriptor.fragmentFunction = ShaderLibrary.fragment(.basic)
        renderPipelineDescriptor.vertexDescriptor = VertexDescriptorLibrary.descriptor(.basic)
        
        return renderPipelineDescriptor
    }
}
