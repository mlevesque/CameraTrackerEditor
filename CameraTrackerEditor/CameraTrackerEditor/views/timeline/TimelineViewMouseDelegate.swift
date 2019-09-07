//
//  TimelineViewDelegate.swift
//  CameraTrackerEditor
//
//  Created by Michael Levesque on 9/2/19.
//  Copyright © 2019 Michael Levesque. All rights reserved.
//

import Cocoa

/**
 Protocol for TimelineView delegate to handle TimelineView mouse events.
 */
protocol TimelineViewMouseDelegate : AnyObject {
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
                                  currentUnitLocation: CGFloat)
    
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
                                currentUnitLocation: CGFloat)
    
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
                             currentUnitLocation: CGFloat)
    
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
                              currentUnitLocation: CGPoint)
    
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
                            currentUnitLocation: CGPoint)
    
    /**
     When the mouse is dragged starting from the horizontal time meter.
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
                         currentUnitLocation: CGPoint)
}
