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
        super.didDragOnTimeMeter(
            sender: sender,
            mouseEvent: mouseEvent,
            startPixelLocation: startPixelLocation,
            currentPixelLocation: currentPixelLocation,
            startUnitLocation: startUnitLocation,
            currentUnitLocation: currentUnitLocation
        )
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
        super.didDragOnUnitMeter(
            sender: sender,
            mouseEvent: mouseEvent,
            startPixelLocation: startPixelLocation,
            currentPixelLocation: currentPixelLocation,
            startUnitLocation: startUnitLocation,
            currentUnitLocation: currentUnitLocation
        )
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
        super.didDragOnGraph(
            sender: sender,
            mouseEvent: mouseEvent,
            startPixelLocation: startPixelLocation,
            currentPixelLocation: currentPixelLocation,
            startUnitLocation: startUnitLocation,
            currentUnitLocation: currentUnitLocation
        )
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
        super.didMouseDownOnTimeline(
            sender: sender,
            mouseEvent: mouseEvent,
            currentPixelLocation: currentPixelLocation,
            currentUnitLocation: currentUnitLocation
        )
        // change to close hand
        changeCursor(inView: sender, withCursor: NSCursor.closedHand)
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
        super.didMouseUpOnTimeline(
            sender: sender,
            mouseEvent: mouseEvent,
            currentPixelLocation: currentPixelLocation,
            currentUnitLocation: currentUnitLocation
        )
        // change to open hand cursor if we are inside the view, otherwise
        // we just reset it. This handles the case of if we had just finished
        // dragging and may be outside the view.
        if sender.frame.contains(mouseEvent.locationInWindow) {
            changeCursor(inView: sender, withCursor: NSCursor.openHand)
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
        super.didMouseEnter(sender: sender, mouseEvent: mouseEvent)
        
        // as long as the mouse isn't being dragged, change cursor to open hand
        if !isDragging {
            changeCursor(inView: sender, withCursor: NSCursor.openHand)
        }
    }
    
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
        changeCursor(inView: view, withCursor: NSCursor.closedHand)
    }
}
