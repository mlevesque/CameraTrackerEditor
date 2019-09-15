//
//  VertexShaderLibrary.swift
//  CameraTrackerEditor
//
//  Created by Michael Levesque on 9/14/19.
//  Copyright © 2019 Michael Levesque. All rights reserved.
//

import MetalKit

/** Types of vertex shaders. */
enum VertexShaderType {
    case basic
    case instanced
}

/**
 Library of all our vertex shader functions.
 */
class VertexShaderLibrary: GraphicsLibrary<VertexShaderType, MTLFunction> {
    /** Dictionary of all vertex shader functions. */
    private var _library: [VertexShaderType: Shader] = [:]
    
    /**
     Fills dictionary of all our vertex shaders.
    */
    override func fillLibrary() {
        _library.updateValue(Shader(name: "Basic Vertex Shader",
                                    functionName: "vertex_basic"),
                             forKey: .basic)
        _library.updateValue(Shader(name: "Instanced Vertex Shader",
                                    functionName: "vertex_instanced"),
                             forKey: .instanced)
    }
    
    /**
     Accessor for vertex shader functions.
     - Parameter type: Type of fragment shader.
     - Returns: The fragment shader function. nil if it doesn't exist.
    */
    override subscript(_ type: VertexShaderType)->MTLFunction {
        return (_library[type]?.function)!
    }
}
