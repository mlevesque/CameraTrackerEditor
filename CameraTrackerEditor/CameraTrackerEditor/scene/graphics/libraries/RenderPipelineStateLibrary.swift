//
//  RenderPipelineStateLibrary.swift
//  CameraTrackerEditor
//
//  Created by Michael Levesque on 9/14/19.
//  Copyright © 2019 Michael Levesque. All rights reserved.
//

import MetalKit

enum RenderPipelineStateType {
    case basic
    case instanced
}

class RenderPipelineStateLibrary: GraphicsLibrary<RenderPipelineStateType, MTLRenderPipelineState> {
    
    private var _library: [RenderPipelineStateType: RenderPipelineState] = [:]
    
    override func fillLibrary() {
        _library.updateValue(RenderPipelineState(renderPipelineDescriptorType: .basic), forKey: .basic)
        _library.updateValue(RenderPipelineState(renderPipelineDescriptorType: .instanced), forKey: .instanced)
    }
    
    override subscript(_ type: RenderPipelineStateType) -> MTLRenderPipelineState {
        return _library[type]!.renderPipelineState
    }
    
}

class RenderPipelineState {
    
    var renderPipelineState: MTLRenderPipelineState!
    init(renderPipelineDescriptorType: RenderPipelineDescriptorType) {
        do{
            renderPipelineState = try SceneEngine.device.makeRenderPipelineState(descriptor: Graphics.renderPipelineDescriptors[renderPipelineDescriptorType])
        } catch let error as NSError {
            print("ERROR::CREATE::RENDER_PIPELINE_STATE::__::\(error)")
        }
    }
    
}
