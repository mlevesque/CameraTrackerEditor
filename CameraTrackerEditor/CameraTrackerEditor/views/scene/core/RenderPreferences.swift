//
//  RenderPreferences.swift
//  CameraTrackerEditor
//
//  Created by Michael Levesque on 9/9/19.
//  Copyright © 2019 Michael Levesque. All rights reserved.
//

import MetalKit

/**
 Various settings for my render pipeline.
 */
class RenderPreferences {
    /** Clear color for the scene view. */
    public static var clearColor = MTLClearColor(red: 0, green: 0, blue: 0, alpha: 1)
    
    /** Pixel format for coloring in the scene view. We are just using a standard format. Nothing fancy */
    public static var pixelFormat = MTLPixelFormat.bgra8Unorm
}
