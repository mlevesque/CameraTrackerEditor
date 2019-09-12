//
//  SceneRenderer.swift
//  CameraTrackerEditor
//
//  Created by Michael Levesque on 9/12/19.
//  Copyright © 2019 Michael Levesque. All rights reserved.
//

import MetalKit

/**
 Handles the responsibility of rendering the scene.
 */
class SceneRenderer : NSObject {
    var gameObject: GameObject = GameObject()
}

extension SceneRenderer : MTKViewDelegate {
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        
    }
    
    /**
     Performs the rendering of the scene.
     - Parameter view: The view to render to.
    */
    func draw(in view: MTKView) {
        guard let drawable = view.currentDrawable, let renderPassDescriptor = view.currentRenderPassDescriptor else {
            return
        }
        
        let commandBuffer = SceneEngine.commandQueue.makeCommandBuffer()
        let renderCommandEncoder = commandBuffer?.makeRenderCommandEncoder(
            descriptor: renderPassDescriptor
        )
        
        gameObject.render(renderCommandEncoder!)
        
        renderCommandEncoder?.endEncoding()
        commandBuffer?.present(drawable)
        commandBuffer?.commit()
    }
}
