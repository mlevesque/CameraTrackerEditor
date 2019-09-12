//
//  SceneView.swift
//  CameraTrackerEditor
//
//  Created by Michael Levesque on 9/9/19.
//  Copyright © 2019 Michael Levesque. All rights reserved.
//

import MetalKit

class SceneView : MTKView {
    
    var renderer: SceneRenderer!
   
    required init(coder: NSCoder) {
        super.init(coder: coder)
        
        self.device = MTLCreateSystemDefaultDevice()
        SceneEngine.initialize(device: self.device!)
        
        self.clearColor = RenderPreferences.clearColor
        self.colorPixelFormat = RenderPreferences.pixelFormat
        self.enableSetNeedsDisplay = true
        
        self.renderer = SceneRenderer()
        self.delegate = renderer
    }
}
