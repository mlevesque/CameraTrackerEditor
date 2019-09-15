//
//  RenderPipelineDescriptorLibrary.swift
//  CameraTrackerEditor
//
//  Created by Michael Levesque on 9/14/19.
//  Copyright © 2019 Michael Levesque. All rights reserved.
//

import MetalKit

enum RenderPipelineDescriptorType {
    case basic
    case instanced
}

class RenderPipelineDescriptorLibrary: GraphicsLibrary<RenderPipelineDescriptorType, MTLRenderPipelineDescriptor> {
    
    private var _library: [RenderPipelineDescriptorType: RenderPipelineDescriptor] = [:]
    
    override func fillLibrary() {
        _library.updateValue(Basic_RenderPipelineDescriptor(), forKey: .basic)
        _library.updateValue(Instanced_RenderPipelineDescriptor(), forKey: .instanced)
        
    }
    
    override subscript(_ type: RenderPipelineDescriptorType) -> MTLRenderPipelineDescriptor {
        return _library[type]!.renderPipelineDescriptor
    }
}

protocol RenderPipelineDescriptor {
    var name: String { get }
    var renderPipelineDescriptor: MTLRenderPipelineDescriptor! { get }
}

public struct Basic_RenderPipelineDescriptor: RenderPipelineDescriptor{
    var name: String = "Basic Render Pipeline Descriptor"
    var renderPipelineDescriptor: MTLRenderPipelineDescriptor!
    init(){
        renderPipelineDescriptor = MTLRenderPipelineDescriptor()
        
        renderPipelineDescriptor.colorAttachments[0].pixelFormat = GraphicsPreferences.mainPixelFormat
        renderPipelineDescriptor.depthAttachmentPixelFormat = GraphicsPreferences.mainDepthPixelFormat
        renderPipelineDescriptor.vertexFunction = Graphics.vertexShaders[.basic]
        renderPipelineDescriptor.fragmentFunction = Graphics.fragmentShaders[.basic]
        renderPipelineDescriptor.vertexDescriptor = Graphics.vertexDescriptors[.basic]
    }
}

public struct Instanced_RenderPipelineDescriptor: RenderPipelineDescriptor{
    var name: String = "Instanced Render Pipeline Descriptor"
    var renderPipelineDescriptor: MTLRenderPipelineDescriptor!
    init(){
        renderPipelineDescriptor = MTLRenderPipelineDescriptor()
        
        renderPipelineDescriptor.colorAttachments[0].pixelFormat = GraphicsPreferences.mainPixelFormat
        renderPipelineDescriptor.depthAttachmentPixelFormat = GraphicsPreferences.mainDepthPixelFormat
        renderPipelineDescriptor.vertexFunction = Graphics.vertexShaders[.instanced]
        renderPipelineDescriptor.fragmentFunction = Graphics.fragmentShaders[.basic]
        renderPipelineDescriptor.vertexDescriptor = Graphics.vertexDescriptors[.basic]
    }
}
