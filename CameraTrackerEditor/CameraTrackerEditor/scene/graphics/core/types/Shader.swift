//
//  Shader.swift
//  CameraTrackerEditor
//
//  Created by Michael Levesque on 9/14/19.
//  Copyright © 2019 Michael Levesque. All rights reserved.
//

import MetalKit

/**
 Basic shader object.
 */
class Shader {
    /** The shader function. */
    var function: MTLFunction!
    
    /**
     Constructor.
    */
    init(name: String, functionName: String) {
        self.function = SceneEngine.defaultLibrary.makeFunction(name: functionName)
        self.function.label = name
    }
}
