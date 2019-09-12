//
//  SceneEngine.swift
//  CameraTrackerEditor
//
//  Created by Michael Levesque on 9/9/19.
//  Copyright © 2019 Michael Levesque. All rights reserved.
//

import MetalKit

/**
 Static class containing Metal-specific objects that will be referenced a bunch.
 */
class SceneEngine {
    /** The GPU device. */
    private static var _device: MTLDevice!
    /** Command queue for setting up renders. */
    private static var _commandQueue: MTLCommandQueue!
    
    /** The GPU device. */
    public static var device: MTLDevice {
        return _device
    }
    
    /** Command queue for setting up renders. */
    public static var commandQueue: MTLCommandQueue {
        return _commandQueue
    }
    
    /**
     This should be called when the scene view initializes. Will store the essential Metal-specific objects.
     - Parameter device: The GPU device that will be performing the renders.
    */
    public static func initialize(device: MTLDevice) {
        _device = device
        _commandQueue = device.makeCommandQueue()
        
        // initialize all libraries
        // These should be initialized in this order
        ShaderLibrary.initialize()
        VertexDescriptorLibrary.initialize()
        RenderPipelineDescriptorLibrary.initialize()
        RenderPipelineStateLibrary.initialize()
    }
}
