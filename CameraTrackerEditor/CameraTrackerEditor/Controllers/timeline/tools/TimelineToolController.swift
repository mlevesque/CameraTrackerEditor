//
//  TimelinePointerController.swift
//  CameraTrackerEditor
//
//  Created by Michael Levesque on 9/6/19.
//  Copyright © 2019 Michael Levesque. All rights reserved.
//

import Cocoa

/**
 Base class for the tool controllers. Meant to be subclassed.
 */
class TimelineToolController : TimelineViewMouseDelegate {
    /** Flag for if we are currently dragging the mouse. */
    private var _isDragging: Bool = false
    
    /** Returns if mouse is currently dragging or not. */
    var isDragging: Bool { get { return _isDragging } }
    
    /**
     Changes the cursor to teh given cursor for the given view.
     - Parameter inView: The view for the cursor.
     - Parameter withCursor: The cursor to change to.
    */
    func changeCursor(inView view: NSView, withCursor cursor: NSCursor) {
        view.addCursorRect(view.bounds, cursor: cursor)
        cursor.set()
    }
    
    /**
     Resets the cursor to the arrow cursor in the given view.
     - Parameter inView: The view for the cursor.
    */
    func resetCursor(inView view: NSView) {
        changeCursor(inView: view, withCursor: NSCursor.arrow)
    }
    
    /**
     When a mouse down event occurs somewhere on the horizontal time meter.
     - Parameter sender: Who sent the event.
     - Parameter mouseEvent: The mouse event that was dispatched.
     - Parameter currentPixelLocation: Current mouse location in pixel space.
     - Parameter currentUnitLocation: Current mouse location in unit space.
    */
    func didMouseDownOnTimeMeter( sender: TimelineView,
                                  mouseEvent: NSEvent,
                                  currentPixelLocation: CGFloat,
                                  currentUnitLocation: CGFloat) {
        
    }
    
    /**
     When a mouse up event occurs somewhere on the horizontal time meter.
     - Parameter sender: Who sent the event.
     - Parameter mouseEvent: The mouse event that was dispatched.
     - Parameter currentPixelLocation: Current mouse location in pixel space.
     - Parameter currentUnitLocation: Current mouse location in unit space.
    */
    func didMouseUpOnTimeMeter( sender: TimelineView,
                                mouseEvent: NSEvent,
                                currentPixelLocation: CGFloat,
                                currentUnitLocation: CGFloat) {
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
    func didDragOnTimeMeter( sender: TimelineView,
                             mouseEvent: NSEvent,
                             startPixelLocation: CGFloat,
                             currentPixelLocation: CGFloat,
                             startUnitLocation: CGFloat,
                             currentUnitLocation: CGFloat) {
    }
    
    /**
     When a mouse down event occurs somewhere on the vertical unit meter.
     - Parameter sender: Who sent the event.
     - Parameter mouseEvent: The mouse event that was dispatched.
     - Parameter currentPixelLocation: Current mouse location in pixel space.
     - Parameter currentUnitLocation: Current mouse location in unit space.
     */
    func didMouseDownOnUnitMeter( sender: TimelineView,
                                  mouseEvent: NSEvent,
                                  currentPixelLocation: CGFloat,
                                  currentUnitLocation: CGFloat) {
        
    }
    
    /**
     When a mouse up event occurs somewhere on the vertical unit meter.
     - Parameter sender: Who sent the event.
     - Parameter mouseEvent: The mouse event that was dispatched.
     - Parameter currentPixelLocation: Current mouse location in pixel space.
     - Parameter currentUnitLocation: Current mouse location in unit space.
     */
    func didMouseUpOnUnitMeter( sender: TimelineView,
                                mouseEvent: NSEvent,
                                currentPixelLocation: CGFloat,
                                currentUnitLocation: CGFloat) {
        
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
    func didDragOnUnitMeter( sender: TimelineView,
                             mouseEvent: NSEvent,
                             startPixelLocation: CGFloat,
                             currentPixelLocation: CGFloat,
                             startUnitLocation: CGFloat,
                             currentUnitLocation: CGFloat) {
        
    }
    
    /**
     When a mouse down event occurs somewhere on the graph.
     - Parameter sender: Who sent the event.
     - Parameter mouseEvent: The mouse event that was dispatched.
     - Parameter currentPixelLocation: Current mouse location in pixel space.
     - Parameter currentUnitLocation: Current mouse location in unit space.
    */
    func didMouseDownOnGraph( sender: TimelineView,
                              mouseEvent: NSEvent,
                              currentPixelLocation: CGPoint,
                              currentUnitLocation: CGPoint) {
        
    }
    
    /**
     When a mouse up event occurs somewhere on the graph.
     - Parameter sender: Who sent the event.
     - Parameter mouseEvent: The mouse event that was dispatched.
     - Parameter currentPixelLocation: Current mouse location in pixel space.
     - Parameter currentUnitLocation: Current mouse location in unit space.
    */
    func didMouseUpOnGraph( sender: TimelineView,
                            mouseEvent: NSEvent,
                            currentPixelLocation: CGPoint,
                            currentUnitLocation: CGPoint) {
    }
    
    /**
     When the mouse is dragged starting from the graph.
     - Parameter sender: Who sent the event.
     - Parameter mouseEvent: The mouse event that was dispatched.
     - Parameter startPixelLocation: Starting mouse location in pixel space.
     - Parameter currentPixelLocation: Current mouse location in pixel space.
     - Parameter startUnitLocation: Starting mouse location in unit space.
     - Parameter currentUnitLocation: Current mouse location in unit space.
    */
    func didDragOnGraph( sender: TimelineView,
                         mouseEvent: NSEvent,
                         startPixelLocation: CGPoint,
                         currentPixelLocation: CGPoint,
                         startUnitLocation: CGPoint,
                         currentUnitLocation: CGPoint) {
    }
    
    /**
     When a mouse down event occurs somewhere on the full timeline.
     - Parameter sender: Who sent the event.
     - Parameter mouseEvent: The mouse event that was dispatched.
     - Parameter currentPixelLocation: Current mouse location in pixel space.
     - Parameter currentUnitLocation: Current mouse location in unit space.
     */
    func didMouseDownOnTimeline( sender: TimelineView,
                                 mouseEvent: NSEvent,
                                 currentPixelLocation: CGPoint,
                                 currentUnitLocation: CGPoint) {
        
    }
    
    /**
     When a mouse up event occurs somewhere on the full timeline.
     - Parameter sender: Who sent the event.
     - Parameter mouseEvent: The mouse event that was dispatched.
     - Parameter currentPixelLocation: Current mouse location in pixel space.
     - Parameter currentUnitLocation: Current mouse location in unit space.
     */
    func didMouseUpOnTimeline( sender: TimelineView,
                               mouseEvent: NSEvent,
                               currentPixelLocation: CGPoint,
                               currentUnitLocation: CGPoint) {
        _isDragging = false
    }
    
    /**
     When the mouse is dragged starting from anywhere on the timeline.
     - Parameter sender: Who sent the event.
     - Parameter mouseEvent: The mouse event that was dispatched.
     - Parameter startPixelLocation: Starting mouse location in pixel space.
     - Parameter currentPixelLocation: Current mouse location in pixel space.
     - Parameter startUnitLocation: Starting mouse location in unit space.
     - Parameter currentUnitLocation: Current mouse location in unit space.
     */
    func didDragOnTimeline( sender: TimelineView,
                            mouseEvent: NSEvent,
                            startPixelLocation: CGPoint,
                            currentPixelLocation: CGPoint,
                            startUnitLocation: CGPoint,
                            currentUnitLocation: CGPoint) {
        _isDragging = true
    }
    
    /**
     When the mouse enters the timeline view.
     - Parameter sender: Who sent the event.
     - Parameter mouseEvent: The mouse event that was dispatched.
    */
    func didMouseEnter( sender: TimelineView,
                        mouseEvent: NSEvent) {
    }
    
    /**
     When the mouse exits the timeline view.
     - Parameter sender: Who sent the event.
     - Parameter mouseEvent: The mouse event that was dispatched.
    */
    func didMouseExit( sender: TimelineView,
                       mouseEvent: NSEvent) {
        // change cursor back if when we are outside view and are not dragging.
        if !isDragging {
            resetCursor(inView: sender)
        }
    }
}
