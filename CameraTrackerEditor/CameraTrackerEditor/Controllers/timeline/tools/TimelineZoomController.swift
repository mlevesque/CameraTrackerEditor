//
//  TimelineZoomController.swift
//  CameraTrackerEditor
//
//  Created by Michael Levesque on 9/6/19.
//  Copyright © 2019 Michael Levesque. All rights reserved.
//

import Cocoa

/**
 Controller for the zoom tool.
*/
class TimelineZoomController : TimelineToolController {
    /** Value multiplier to zoom by. */
    private let zoomMultiplier: CGSize = CGSize(width: 2, height: 2)
    
    /**
     When a mouse up event occurs somewhere on the graph.
     - Parameter sender: Who sent the event.
     - Parameter mouseEvent: The mouse event that was dispatched.
     - Parameter currentPixelLocation: Current mouse location in pixel space.
     - Parameter currentUnitLocation: Current mouse location in unit space.
    */
    override func didMouseUpOnGraph( sender: TimelineView,
                                     mouseEvent: NSEvent,
                                     currentPixelLocation: CGPoint,
                                     currentUnitLocation: CGPoint) {
        // if option key is down, then zoom out
        let optionKeyDown = mouseEvent.modifierFlags.contains(.option)
        let zoomAmount = optionKeyDown
            ? CGSize( // zoom out
                width: 1 / zoomMultiplier.width,
                height: 1 / zoomMultiplier.height
                )
            : CGSize( // zoom in
                width: zoomMultiplier.width,
                height: zoomMultiplier.height
        )
        
        // perform zoom
        zoom(
            withView: sender,
            atUnitPosition: currentUnitLocation,
            withUnitZoom: zoomAmount
        )
    }
    
    /**
     Performs the zoom in the timeline at the given position.
     - Parameter withView: The view to affect.
     - Parameter atUnitPosition: The position to focus the zoom to, in unit
        space.
     - Parameter withUnitZoom: The zoom amount to multiply to the scale.
    */
    private func zoom( withView view: TimelineView,
                       atUnitPosition pos: CGPoint,
                       withUnitZoom zoom: CGSize) {
        // This is the new positional transform value
        // We apply a half length of the timeline so that the zoom position is
        // centered
        let adjustedUnitLength = CGSize(
            width: view.unitLength.width / zoom.width,
            height: view.unitLength.height / zoom.height
        )
        let newPosition = pos - adjustedUnitLength / 2
        
        // calculate the new scale
        // NOTE: Zoom values are flipped here because:
        // Zooming in -> scaling down in the timeline
        // Zooming out -> scaling up in the timeline
        let newScale = CGSize(
            width: view.scale.width / zoom.width,
            height: view.scale.height / zoom.height
        )
        
        // apply position and scale
        view.startUnitPosition = newPosition
        view.scale = newScale
    }
}
