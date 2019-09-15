//
//  LightObject.swift
//  CameraTrackerEditor
//
//  Created by Michael Levesque on 9/14/19.
//  Copyright © 2019 Michael Levesque. All rights reserved.
//

import MetalKit

class LightObject: ObjectNode {
    
    var lightData = LightData()
    
    init(name: String) {
        super.init(meshType: .None)
        self.name = name
    }
    
    init(meshType: MeshTypes, name: String) {
        super.init(meshType: meshType)
        self.name = name
    }
    
    override func update(timeStamp: Double) {
        self.lightData.position = self.position
        super.update(timeStamp: timeStamp)
    }
}

extension LightObject {
    // Light Color
    public func setLightColor(_ color: float3) { self.lightData.color = color }
    public func getLightColor()->float3 { return self.lightData.color }
    
    // Light Brightness
    public func setLightBrightness(_ brightness: Float) { self.lightData.brightness = brightness }
    public func getLightBrightness()->Float { return self.lightData.brightness }
    
    // Ambient Intensity
    public func setLightAmbientIntensity(_ intensity: Float) { self.lightData.ambientIntensity = intensity }
    public func getLightAmbientIntensity()->Float { return self.lightData.ambientIntensity }
    
    // Diffuse Intensity
    public func setLightDiffuseIntensity(_ intensity: Float) { self.lightData.diffuseIntensity = intensity }
    public func getLightDiffuseIntensity()->Float { return self.lightData.diffuseIntensity }
}
