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
    
    public static var device: MTLDevice!
    public static var commandQueue: MTLCommandQueue!
    public static var defaultLibrary: MTLLibrary!
    
    public static func initialize(device: MTLDevice){
        self.device = device
        self.commandQueue = device.makeCommandQueue()
        self.defaultLibrary = device.makeDefaultLibrary()
        
        Graphics.initialize()
        
        //Entities.Initialize()
        
        SceneManager.initialize(currentSceneType: GraphicsPreferences.startingSceneType)
        
    }
    
}
