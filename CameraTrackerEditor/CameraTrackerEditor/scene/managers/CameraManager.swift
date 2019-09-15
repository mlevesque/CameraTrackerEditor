//
//  CameraManager.swift
//  CameraTrackerEditor
//
//  Created by Michael Levesque on 9/14/19.
//  Copyright © 2019 Michael Levesque. All rights reserved.
//

/**
 Manages a list of cameras and the currently active camera for a scene.
 */
class CameraManager {
    /** The currently active camera. */
    private var _currentCamera: Camera?
    /** The main camera for the scene that is controlled by the tracking data. */
    private var _mainCamera: Camera?
    /** List of all cameras for the scene. */
    private var _cameras: [Camera] = []
    
    /** The currently active camera. */
    var currentCamera: Camera? { return _currentCamera }
    /** The main camera for the scene that is controlled by the tracking data. */
    var mainCamera: Camera? { return _mainCamera }
    /** List of all cameras. */
    var cameras: [Camera] { return _cameras }
    
    /**
     Adds the given camera to the list.
     - Parameter camera: The camera to add.
    */
    func addCamera(_ camera: Camera) {
        _cameras.append(camera)
        if camera.type == .main {
            _mainCamera = camera
        }
    }
    
    /**
     Removes the given camera from the list. If the camera is active, then we will change the current camera to the
     first camera in the list.
     - Parameter camera: The camera to remove.
    */
    func removeCamera(_ camera: Camera) {
        if let i = _cameras.firstIndex(of: camera) {
            _cameras.remove(at: i)
        }
        if _currentCamera == camera {
            _currentCamera = _cameras.first
        }
    }
    
    /**
     Sets the given camera as the currently active one. If the given camera is not already in the list of cameras, then
     it will be added.
     - Parameter camera: The camera to set as the currently active one for the scene.
    */
    func setCameraAsCurrent(_ camera: Camera) {
        //make sure camera is listed in list
        if !hasCamera(camera) {
            addCamera(camera)
        }
        _currentCamera = camera
    }
    
    /**
     Sets the main camera as the currently active camera.
    */
    func setMainCameraAsCurrent() {
        if let main = _mainCamera {
            _currentCamera = main
        }
    }
    
    internal func updateCameras(timeStamp: Double) {
        for camera in _cameras {
            camera.updateCamera(timeStamp: timeStamp)
        }
    }
    
    /**
     Returns true if the given camera is already in the list.
     - Parameter camera: The camera to check for.
     - Returns: true if the camera is in the list. false if not.
    */
    private func hasCamera(_ camera: Camera) -> Bool {
        return _cameras.firstIndex(of: camera) != nil
    }
}
