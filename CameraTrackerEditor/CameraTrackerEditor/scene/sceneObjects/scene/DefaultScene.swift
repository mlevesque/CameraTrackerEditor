//
//  DefaultScene.swift
//  CameraTrackerEditor
//
//  Created by Michael Levesque on 9/15/19.
//  Copyright © 2019 Michael Levesque. All rights reserved.
//

import MetalKit

/**
 Default scene setup with a tracking camera and objects to help indicate visually that the tracking camera is updating.
 */
class DefaultSceneNode : SceneNode {
    /**
     Constructor.
     */
    override init(name: String = "Default Scene Node") {
        super.init(name: name)
        initialize()
    }
    
    /**
     Sets up the scene with objects.
    */
    private func initialize() {
        let mainCamera = TarckingCamera()
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
