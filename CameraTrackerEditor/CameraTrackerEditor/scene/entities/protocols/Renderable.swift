//
//  Renderable.swift
//  CameraTrackerEditor
//
//  Created by Michael Levesque on 9/13/19.
//  Copyright © 2019 Michael Levesque. All rights reserved.
//

import MetalKit

/**
 Protocol to given to Node subclasses that need to render something.
 */
protocol Renderable {
    /** Flag for whether or not the node should be rendered. */
    var shouldRender: Bool { get set }
    /** Will get called when it is time to render the node. */
    func doRender(_ renderCommandEncoder: MTLRenderCommandEncoder)
}
