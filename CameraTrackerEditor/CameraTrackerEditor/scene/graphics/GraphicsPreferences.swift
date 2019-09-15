//
//  GraphicsPreferences.swift
//  CameraTrackerEditor
//
//  Created by Michael Levesque on 9/14/19.
//  Copyright © 2019 Michael Levesque. All rights reserved.
//

import MetalKit

class GraphicsPreferences {
    
    public static var clearColor: MTLClearColor = MTLClearColor(red: 0, green: 0, blue: 0, alpha: 1)
    
    public static var mainPixelFormat: MTLPixelFormat = MTLPixelFormat.bgra8Unorm_srgb
    
    public static var mainDepthPixelFormat: MTLPixelFormat = MTLPixelFormat.invalid
    
    public static var startingSceneType: SceneType = SceneType.defaultScene
    
}
