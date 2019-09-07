//
//  TimelineHandController.swift
//  CameraTrackerEditor
//
//  Created by Michael Levesque on 9/6/19.
//  Copyright © 2019 Michael Levesque. All rights reserved.
//

import Cocoa

/**
 Controller for the Hand tool.
 */
class TimelineHandController : TimelineToolController {
    /**
     When the mouse is dragged starting from the horizontal time meter.
     - Parameter sender: Who sent the event.
     - Parameter mouseEvent: The mouse event that was dispatched.
     - Parameter startPixelLocation: Starting mouse location in pixel space.
     - Parameter currentPixelLocation: Current mouse location in pixel space.
     - Parameter startUnitLocation: Starting mouse location in unit space.
     - Parameter currentUnitLocation: Current mouse location in unit space.
    */
    override func didDragOnGraph( sender: TimelineView,
                                  mouseEvent: NSEvent,
                                  startPixelLocation: CGPoint,
                                  currentPixelLocation: CGPoint,
                                  startUnitLocation: CGPoint,
                                  currentUnitLocation: CGPoint) {
        // Use the delta values in the mouse event and move the timeline by
        // those values, in pixel space.
        let startPos = sender.startPixelPosition
        sender.startPixelPosition = CGPoint(
            x: startPos.x - mouseEvent.deltaX,
            y: startPos.y + mouseEvent.deltaY
        )
    }
}
