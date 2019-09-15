//
//  DepthStencilStateLibrary.swift
//  CameraTrackerEditor
//
//  Created by Michael Levesque on 9/14/19.
//  Copyright © 2019 Michael Levesque. All rights reserved.
//

import MetalKit

enum DepthStencilStateType {
    case less
}

class DepthStencilStateLibrary: GraphicsLibrary<DepthStencilStateType, MTLDepthStencilState> {
    
    private var _library: [DepthStencilStateType: DepthStencilState] = [:]
    
    override func fillLibrary() {
        _library.updateValue(Less_DepthStencilState(), forKey: .less)
    }
    
    override subscript(_ type: DepthStencilStateType)->MTLDepthStencilState{
        return _library[type]!.depthStencilState
    }
    
}

protocol DepthStencilState {
    var depthStencilState: MTLDepthStencilState! { get }
}

class Less_DepthStencilState: DepthStencilState {
    
    var depthStencilState: MTLDepthStencilState!
    
    init() {
        let depthStencilDescriptor = MTLDepthStencilDescriptor()
        depthStencilDescriptor.isDepthWriteEnabled = true
        depthStencilDescriptor.depthCompareFunction = .less
        depthStencilState = SceneEngine.device.makeDepthStencilState(descriptor: depthStencilDescriptor)
    }
    
}
