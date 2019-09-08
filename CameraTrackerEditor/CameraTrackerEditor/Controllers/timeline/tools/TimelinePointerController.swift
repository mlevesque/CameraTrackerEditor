//
//  TimelinePointerController.swift
//  CameraTrackerEditor
//
//  Created by Michael Levesque on 9/6/19.
//  Copyright © 2019 Michael Levesque. All rights reserved.
//

import Cocoa

/**
 Controller for the Pointer tool for the Timeline.
 */
class TimelinePointerController : TimelineToolController {
    /**
     Called when this controller's tool is first selected.
     - Parameter forView: The timeline view.
     */
    override func onStart( forView view: TimelineView ) {
        resetCursor(inView: view)
    }
    
    /**
     When a mouse up event occurs somewhere on the horizontal time meter.
     - Parameter sender: Who sent the event.
     - Parameter mouseEvent: The mouse event that was dispatched.
     - Parameter currentPixelLocation: Current mouse location in pixel space.
     - Parameter currentUnitLocation: Current mouse location in unit space.
     */
    override func didMouseUpOnTimeMeter( sender: TimelineView,
                                         mouseEvent: NSEvent,
                                         currentPixelLocation: CGFloat,
                                         currentUnitLocation: CGFloat) {
        sender.playheadUnitPosition = currentUnitLocation
    }
    
    /**
     When the mouse is dragged from the horizontal time meter.
     - Parameter sender: Who sent the event.
     - Parameter mouseEvent: The mouse event that was dispatched.
     - Parameter startPixelLocation: Starting mouse location in pixel space.
     - Parameter currentPixelLocation: Current mouse location in pixel space.
     - Parameter startUnitLocation: Starting mouse location in unit space.
     - Parameter currentUnitLocation: Current mouse location in unit space.
     */
    override func didDragOnTimeMeter( sender: TimelineView,
                                      mouseEvent: NSEvent,
                                      startPixelLocation: CGFloat,
                                      currentPixelLocation: CGFloat,
                                      startUnitLocation: CGFloat,
                                      currentUnitLocation: CGFloat) {
        sender.playheadUnitPosition = currentUnitLocation
    }
}
