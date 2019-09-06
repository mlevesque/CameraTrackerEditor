//
//  SceneViewController.swift
//  CameraTrackerEditor
//
//  Created by Michael Levesque on 9/5/19.
//  Copyright © 2019 Michael Levesque. All rights reserved.
//

import MetalKit

class SceneViewController : NSViewController {
    var renderer: SceneRenderer?
    
    override func viewDidLoad() {
        guard let metalView = view as? MTKView else {
            fatalError("metal view not set up in storyboard")
        }
        
        renderer = SceneRenderer(metalView: metalView)
    }
}
