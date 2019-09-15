//
//  Camera.swift
//  CameraTrackerEditor
//
//  Created by Michael Levesque on 9/14/19.
//  Copyright © 2019 Michael Levesque. All rights reserved.
//

import MetalKit

/** Indicates what kind of camera a given camera is. */
enum CameraType {
    /** Base camera. */
    case base
    /** Main camera that is controlled by the tracking data. */
    case main
    /** Free camera that can be moved around by the user. */
    case debug
}

/**
 Camera node representing a camera in the scene.
 */
class Camera : Node {
    /** The type of camera this camera represents. */
    internal var _cameraType: CameraType
    /** MDL Camera object that helps with pojection calculations based on real world camera specs. */
    private var _mdlCamera: MDLCamera
    /** Crop factor for camera sensors that affects final focal length. */
    private var _cropFactor: Float
    
    
    /** The type of camera. */
    var type: CameraType { return _cameraType }
    
    /** Camera View Matrix. */
    var viewMatrix: matrix_float4x4 {
        var viewMatrix = matrix_identity_float4x4
        viewMatrix.rotate(angle: self.rotationX, axis: X_AXIS)
        viewMatrix.rotate(angle: self.rotationY, axis: Y_AXIS)
        viewMatrix.rotate(angle: self.rotationZ, axis: Z_AXIS)
        viewMatrix.translate(direction: -position)
        return viewMatrix
    }
    
    /** Camera projection matrix taken from the MDL Camera. */
    var projectionMatrix: matrix_float4x4 {
        return _mdlCamera.projectionMatrix
    }
    
    /** Crop factor for camera sensor that affects the final focal length. */
    var cropFactor: Float {
        get { return _cropFactor }
        set(value) { _cropFactor = value }
    }
    
    /** The focal length of the camera before the crop factor. */
    var focalLength: Float {
        get { return _mdlCamera.focalLength / _cropFactor }
        set(value) { _mdlCamera.focalLength = value * _cropFactor }
    }
    
    /** The focal length after factoring in crop factor. */
    var finalFocalLength: Float {
        get { return _mdlCamera.focalLength }
        set(value) { _mdlCamera.focalLength = value }
    }
    
    /** Lens barrel distortion. */
    var barrelDistortion: Float {
        get { return _mdlCamera.barrelDistortion }
        set(value) { _mdlCamera.barrelDistortion = value }
    }
    
    /** Fisheye distortion for very wide angle lenses. */
    var fisheyeDistortion: Float {
        get { return _mdlCamera.fisheyeDistortion }
        set(value) { _mdlCamera.fisheyeDistortion = value }
    }
    
    
    /**
     Constructor.
    */
    override init(name: String = "Camera") {
        _cameraType = .base
        _mdlCamera = MDLCamera()
        _cropFactor = 1
        super.init(name: name)
    }
    
    func updateCamera(timeStamp: Double) {}
}

/**
 Represents the main camera that is controlled by the tracking data.
 */
class MainCamera : Camera {
    /**
     Constructor.
    */
    override init(name: String = "Main Camera") {
        super.init(name: name)
        _cameraType = .main
    }
    
    /**
     Updates the main camera with the tracking data at the given time.
     - Parameter timeStamp: The timestamp to use to get the camera position and rotation.
    */
    override func updateCamera(timeStamp: Double) {
        guard let entry = TrackingDataManager.currentData?.getData(atTime: timeStamp) else {
            return
        }
        let p = entry.position
        let r = entry.rotation
        self.position = float3(p.x, p.y, p.z)
        self.rotation = float3(r.x, r.y, r.z)
    }
}
