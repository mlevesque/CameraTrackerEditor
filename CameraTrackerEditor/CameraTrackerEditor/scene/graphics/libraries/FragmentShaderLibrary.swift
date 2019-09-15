//
//  FragmentShaderLibrary.swift
//  CameraTrackerEditor
//
//  Created by Michael Levesque on 9/14/19.
//  Copyright © 2019 Michael Levesque. All rights reserved.
//

import MetalKit

/** Types of fragment shaders. */
enum FragmentShaderType {
    case basic
}

/**
 Library of fragment shader functions.
 */
class FragmentShaderLibrary: GraphicsLibrary<FragmentShaderType, MTLFunction> {
    /** Dictionary of fragment shader functions. */
    private var _library: [FragmentShaderType: Shader] = [:]
    
    /**
     Fills dictionary of all out fragment shaders.
    */
    override func fillLibrary() {
        _library.updateValue(Shader(name: "Basic Fragment Shader",
                                    functionName: "fragment_basic"),
                             forKey: .basic)
    }
    
    /**
     Accessor for fragment shader functions.
     - Parameter type: Type of fragment shader.
     - Returns: The fragment shader function. nil if it doesn't exist.
    */
    override subscript(_ type: FragmentShaderType) -> MTLFunction {
        return (_library[type]?.function)!
    }
}
