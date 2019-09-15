//
//  SamplerStateLibrary.swift
//  CameraTrackerEditor
//
//  Created by Michael Levesque on 9/14/19.
//  Copyright © 2019 Michael Levesque. All rights reserved.
//

import MetalKit

enum SamplerStateType {
    case none
    case linear
}

class SamplerStateLibrary: GraphicsLibrary<SamplerStateType, MTLSamplerState> {
    
    private var library: [SamplerStateType : SamplerState] = [:]
    
    override func fillLibrary() {
        library.updateValue(Linear_SamplerState(), forKey: .linear)
    }
    
    override subscript(_ type: SamplerStateType) -> MTLSamplerState {
        return (library[type]?.samplerState!)!
    }
    
}

protocol SamplerState {
    var name: String { get }
    var samplerState: MTLSamplerState! { get }
}

class Linear_SamplerState: SamplerState {
    var name: String = "Linear Sampler State"
    var samplerState: MTLSamplerState!
    
    init() {
        let samplerDescriptor = MTLSamplerDescriptor()
        samplerDescriptor.minFilter = .linear
        samplerDescriptor.magFilter = .linear
        samplerDescriptor.label = name
        samplerState = SceneEngine.device.makeSamplerState(descriptor: samplerDescriptor)
    }
}
