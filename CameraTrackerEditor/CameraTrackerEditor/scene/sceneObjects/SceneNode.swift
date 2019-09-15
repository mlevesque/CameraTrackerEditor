//
//  SceneNode.swift
//  CameraTrackerEditor
//
//  Created by Michael Levesque on 9/13/19.
//  Copyright © 2019 Michael Levesque. All rights reserved.
//

import simd

/**
 Represents a scene of cameras and other nodes. There should only be one active scene at a time and should always be
 the top level of the Node hierarchy.
 */
class SceneNode : Node {
    /** Manages all cameras for the scene. */
    private var _cameraManager = CameraManager()
    /** Constants for teh scene used for the shaders. */
    private var _sceneConstants = SceneConstants()
    /** The time stamp position in the tracking data. */
    private var _timePosition: Double = 0
    
    /** Manages the cameras for the scene. */
    var cameraManager: CameraManager { return _cameraManager }
    
    
    /**
     Constructor.
    */
    override init(name: String = "Scene Node") {
        super.init(name: name)
    }
    
    
    /**
     Update contraints after all children have been updated.
     - Parameter timeStamp: The timestamp for the tracking data.
    */
    override func doUpdateAfterChildren(timeStamp: Double) {
        updateSceneConstants()
    }
    
    /**
     Updates the constants with the current camera.
    */
    private func updateSceneConstants() {
        let currentCamera = _cameraManager.currentCamera
        _sceneConstants.viewMatrix = currentCamera?.viewMatrix ?? matrix_identity_float4x4
        _sceneConstants.projectionMatrix = currentCamera?.projectionMatrix ?? matrix_identity_float4x4
    }
}

class DefaultSceneNode : SceneNode {
    /**
     Constructor.
    */
    override init(name: String = "Default Scene Node") {
        super.init(name: name)
    }
    
    private func initialize() {
        let mainCamera = MainCamera()
        mainCamera.focalLength = 35
        cameraManager.addCamera(mainCamera)
        mainCamera.parent = self
    }
}
