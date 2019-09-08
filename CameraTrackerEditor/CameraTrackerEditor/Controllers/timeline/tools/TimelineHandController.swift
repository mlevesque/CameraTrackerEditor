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
     Called when this controller's tool is first selected.
     - Parameter forView: The timeline view.
     */
    override func onStart( forView view: TimelineView ) {
        changeCursor(withCursor: NSCursor.openHand, inView: view)
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
        performDrag(
            view: sender,
            delta: CGSize(width: mouseEvent.deltaX, height: 0)
        )
    }
    
    /**
     When the mouse is dragged from the vertical unit meter.
     - Parameter sender: Who sent the event.
     - Parameter mouseEvent: The mouse event that was dispatched.
     - Parameter startPixelLocation: Starting mouse location in pixel space.
     - Parameter currentPixelLocation: Current mouse location in pixel space.
     - Parameter startUnitLocation: Starting mouse location in unit space.
     - Parameter currentUnitLocation: Current mouse location in unit space.
     */
    override func didDragOnUnitMeter( sender: TimelineView,
                                      mouseEvent: NSEvent,
                                      startPixelLocation: CGFloat,
                                      currentPixelLocation: CGFloat,
                                      startUnitLocation: CGFloat,
                                      currentUnitLocation: CGFloat) {
        performDrag(
            view: sender,
            delta: CGSize(width: 0, height: mouseEvent.deltaY)
        )
    }
    
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
        performDrag(
            view: sender,
            delta: CGSize(width: mouseEvent.deltaX, height: mouseEvent.deltaY)
        )
    }
    
    /**
     When a mouse down event occurs somewhere on the full timeline.
     - Parameter sender: Who sent the event.
     - Parameter mouseEvent: The mouse event that was dispatched.
     - Parameter currentPixelLocation: Current mouse location in pixel space.
     - Parameter currentUnitLocation: Current mouse location in unit space.
     */
    override func didMouseDownOnTimeline( sender: TimelineView,
                                          mouseEvent: NSEvent,
                                          currentPixelLocation: CGPoint,
                                          currentUnitLocation: CGPoint) {
        // change to close hand
        changeCursor(withCursor: NSCursor.closedHand, inView: sender)
    }
    
    /**
     When a mouse up event occurs somewhere on the full timeline.
     - Parameter sender: Who sent the event.
     - Parameter mouseEvent: The mouse event that was dispatched.
     - Parameter currentPixelLocation: Current mouse location in pixel space.
     - Parameter currentUnitLocation: Current mouse location in unit space.
     */
    override func didMouseUpOnTimeline( sender: TimelineView,
                                        mouseEvent: NSEvent,
                                        currentPixelLocation: CGPoint,
                                        currentUnitLocation: CGPoint) {
        // change to open hand cursor if we are inside the view, otherwise
        // we just reset it. This handles the case of if we had just finished
        // dragging and may be outside the view.
        if sender.frame.contains(mouseEvent.locationInWindow) {
            changeCursor(withCursor: NSCursor.openHand, inView: sender)
        }
        else {
            resetCursor(inView: sender)
        }
    }
    
    /**
     When the mouse enters the timeline view.
     - Parameter sender: Who sent the event.
     - Parameter mouseEvent: The mouse event that was dispatched.
     */
    override func didMouseEnter( sender: TimelineView,
                                 mouseEvent: NSEvent) {
        // as long as the mouse isn't being dragged, change cursor to open hand
        if !sender.mouseIsDragging {
            changeCursor(withCursor: NSCursor.openHand, inView: sender)
        }
    }
    
    
    /**
     Performs the scrolling when the mouse drags from the timeline.
    */
    private func performDrag( view: TimelineView,
                              delta: CGSize) {
        // Use the delta values in the mouse event and move the timeline by
        // those values, in pixel space.
        let startPos = view.startPixelPosition
        view.startPixelPosition = CGPoint(
            x: startPos.x - delta.width,
            y: startPos.y + delta.height
        )
        
        // update cursor
        changeCursor(withCursor: NSCursor.closedHand, inView: view)
    }
}
