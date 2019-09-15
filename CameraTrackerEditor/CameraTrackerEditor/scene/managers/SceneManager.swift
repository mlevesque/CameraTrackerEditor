//
//  SceneManager.swift
//  CameraTrackerEditor
//
//  Created by Michael Levesque on 9/14/19.
//  Copyright © 2019 Michael Levesque. All rights reserved.
//

import MetalKit

enum SceneType {
    case defaultScene
}

class SceneManager {
    private static var _currentScene: SceneNode?
    private static var _scenes: [SceneType: SceneNode] = [:]
    
    static var current: SceneNode? { return _currentScene }
    
    static func initialize(currentSceneType type: SceneType = .defaultScene) {
        createDefaultScene()
        setSceneAsCurrent(type)
    }
    
    private static func createDefaultScene() {
        _scenes.updateValue(DefaultSceneNode(), forKey: .defaultScene)
    }
    
    public static func setSceneAsCurrent(_ type: SceneType) {
        _currentScene = _scenes[type]
    }
    
    public static func getScene(_ type: SceneType) -> SceneNode? {
        return _scenes[type]
    }
    
    public static func updateScane(renderCommandEncoder: MTLRenderCommandEncoder) {
        _currentScene?.update(timeStamp: TrackingDataManager.timeStamp)
        _currentScene?.render(renderCommandEncoder: renderCommandEncoder)
    }
}
