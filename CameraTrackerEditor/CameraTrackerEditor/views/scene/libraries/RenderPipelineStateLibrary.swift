//
//  RenderPipelineStateLibrary.swift
//  CameraTrackerEditor
//
//  Created by Michael Levesque on 9/11/19.
//  Copyright © 2019 Michael Levesque. All rights reserved.
//

import MetalKit

/**
 Types of Render Pipeline States.
 */
enum RenderPipelineStateType {
    case basic
}

/**
 Library for all Render Pipeline States.
 */
class RenderPipelineStateLibrary {
    /** Dictionary of Render Pipeline States. */
    private static var renderPipelineStates: [RenderPipelineStateType: RenderPipelineState] = [:]
    
    /**
     Shoudl be called from the Scene Engine. Creates all Render Pipeline States.
    */
    public static func initialize() {
        createDefaultRenderPipelineState()
    }
    
    /**
     Creates all Render Pipeline States and adds them to the dictionary.
    */
    private static func createDefaultRenderPipelineState() {
        renderPipelineStates.updateValue(BasicRenderPipelineState(), forKey: .basic)
    }
    
    /**
     Returns the Render Pipeline State for the given type.
     - Parameter type: The type of the Render Pipeline State to return.
     - Returns: The Render Pipeline State for the given type.
    */
    public static func pipelineState(_ type: RenderPipelineStateType) -> MTLRenderPipelineState {
        return renderPipelineStates[type]!.renderPipelineState
    }
}


/**
 Blueprint for a Render Pipeline State object.
 */
protocol RenderPipelineState {
    /** Display name for the Render Pipeline State. */
    var name: String { get }
    /** The Render Pipeline State. */
    var renderPipelineState: MTLRenderPipelineState { get }
}


/**
 Basic Render Pipeline State.
 */
struct BasicRenderPipelineState : RenderPipelineState {
    var name: String = "Basic Render Pipeline State"
    var renderPipelineState: MTLRenderPipelineState {
        var renderPipelineState: MTLRenderPipelineState!
        do {
            renderPipelineState = try SceneEngine.device.makeRenderPipelineState(
                descriptor: RenderPipelineDescriptorLibrary.descriptor(.basic)
            )
        }
        catch let error as NSError {
            print("Error: Basic Render Pipeline State \(name): \(error)")
        }
        return renderPipelineState
    }
}
