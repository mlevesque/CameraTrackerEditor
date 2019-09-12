//
//  ShaderLibrary.swift
//  CameraTrackerEditor
//
//  Created by Michael Levesque on 9/11/19.
//  Copyright © 2019 Michael Levesque. All rights reserved.
//

import MetalKit

/**
 Enum classifying all the different vertex shaders defined in the app.
 */
enum VertexShaderType {
    case basic
}

/**
 Enum classifying all the different fragment shaders defined in the app.
 */
enum FragmentShaderType {
    case basic
}

/**
 Library containing all my shaders for later reference.
 */
class ShaderLibrary {
    /** Library of the shaders. */
    public static var DefaultLibrary: MTLLibrary!
    
    /** Dictionary of vertex shaders. */
    private static var _vertexShaders: [VertexShaderType: Shader] = [:]
    /** Dictionary of fragment shaders. */
    private static var _fragmentShaders: [FragmentShaderType: Shader] = [:]
    
    /**
     Initializes all the shaders. This should be called when the scene view initializes.
    */
    public static func initialize() {
        DefaultLibrary = SceneEngine.device.makeDefaultLibrary()
        createDefaultShaders()
    }
    
    /**
     Sets up the shaders.
    */
    public static func createDefaultShaders() {
        //Vertex Shaders
        _vertexShaders.updateValue(BasicVertexShader(), forKey: .basic)
        
        //Fragment Shaders
        _fragmentShaders.updateValue(BasicFragmentShader(), forKey: .basic)
    }
    
    /**
     Returns the stored vertex shader of the given type.
     - Parameter vertexShaderType: The type of vertex shader to return.
     - Returns: The vertex shader function.
    */
    public static func vertex(_ vertexShaderType: VertexShaderType) -> MTLFunction {
        return _vertexShaders[vertexShaderType]!.function
    }
    
    /**
     Returns the stored fragment shader of the given type.
     - Parameter vertexShaderType: The type of fragment shader to return.
     - Returns: The fragment shader function.
     */
    public static func fragment(_ fragmentShaderType: FragmentShaderType) -> MTLFunction {
        return _fragmentShaders[fragmentShaderType]!.function
    }
}


/**
 Blueprint for a given shader class implementation.
 */
fileprivate protocol Shader{
    /** Name of the shader. */
    var name: String { get }
    /** Name of the function for the shader as defined in the .metal file. */
    var functionName: String { get }
    /** Holder of the precompiled shader function. */
    var function: MTLFunction { get }
}

// -- VERTEX SHADERS
/**
 Defines the basic vertex shader defined in Shaders.metal.
 */
fileprivate struct BasicVertexShader: Shader {
    public var name: String = "Basic Vertex Shader"
    public var functionName: String = "vertex_basic"
    public var function: MTLFunction {
        let function = ShaderLibrary.DefaultLibrary.makeFunction(name: functionName)
        function?.label = name
        return function!
    }
}


// -- FRAGMENT SHADERS
/**
 Defines the basic fragment shader defined in Shaders.metal
 */
fileprivate struct BasicFragmentShader: Shader {
    public var name: String = "Basic Fragment Shader"
    public var functionName: String = "fragment_basic"
    public var function: MTLFunction {
        let function = ShaderLibrary.DefaultLibrary.makeFunction(name: functionName)
        function?.label = name
        return function!
    }
}
