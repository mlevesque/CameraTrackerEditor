//
//  SceneNode.swift
//  CameraTrackerEditor
//
//  Created by Michael Levesque on 9/13/19.
//  Copyright © 2019 Michael Levesque. All rights reserved.
//

import MetalKit

/**
 Represents a scene of cameras and other nodes. There should only be one active scene at a time and should always be
 the top level of the Node hierarchy.
 */
class SceneNode : Node {
    /** Manages all cameras for the scene. */
    private var _cameraManager = CameraManager()
    private var _lightManager = LightManager()
    /** Constants for teh scene used for the shaders. */
    private var _sceneConstants = SceneConstants()
    /** The time stamp position in the tracking data. */
    private var _timePosition: Double = 0
    
    /** Manages the cameras for the scene. */
    var cameraManager: CameraManager { return _cameraManager }
    var lightManager: LightManager { return _lightManager }
    
    
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
    override func doUpdateBeforeChildren(timeStamp: Double) {
        _cameraManager.updateCameras(timeStamp: timeStamp)
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
    
    override func render(renderCommandEncoder: MTLRenderCommandEncoder) {
        renderCommandEncoder.setVertexBytes(&_sceneConstants, length: SceneConstants.stride, index: 1)
        _lightManager.setLightData(renderCommandEncoder)
        super.render(renderCommandEncoder: renderCommandEncoder)
    }
}

class DefaultSceneNode : SceneNode {
    /**
     Constructor.
    */
    override init(name: String = "Default Scene Node") {
        super.init(name: name)
        initialize()
    }
    
    private func initialize() {
        let mainCamera = MainCamera()
        mainCamera.focalLength = 35
        mainCamera.positionZ = 10
        cameraManager.addCamera(mainCamera)
        cameraManager.setCameraAsCurrent(mainCamera)
        mainCamera.parent = self
        
        let cube = ObjectNode(meshType: .Cube_Custom)
        cube.position = float3(5,-5,-5)
        cube.addMaterialDiffuse(1)
        cube.parent = self
        
        let light = LightObject(name: "Light")
        lightManager.addLightObject(light)
    }
}
