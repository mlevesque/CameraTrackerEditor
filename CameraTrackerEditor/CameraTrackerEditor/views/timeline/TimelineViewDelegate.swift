//
//  TimelineViewDelegate.swift
//  CameraTrackerEditor
//
//  Created by Michael Levesque on 9/2/19.
//  Copyright © 2019 Michael Levesque. All rights reserved.
//

import Cocoa

/**
 Protocol for TimelineView delegates to handle TimelineView events.
 */
protocol TimelineViewDelegate : AnyObject {
    /**
     When the mouse clicks somewhere on the horizontal meter.
     - Parameter sender: Who sent the event.
     - Parameter currentPixelLocation: Current mouse location in pixel space.
     - Parameter currentUnitLocation: Current mouse location in unit space.
    */
    func didClickOnHorizontalMeter( sender: TimelineView,
                                    currentPixelLocation: CGFloat,
                                    currentUnitLocation: CGFloat)
    
    /**
     When the mouse is dragged from the horizontal meter.
     - Parameter sender: Who sent the event.
     - Parameter startPixelLocation: Starting mouse location in pixel space.
     - Parameter currentPixelLocation: Current mouse location in pixel space.
     - Parameter startUnitLocation: Starting mouse location in unit space.
     - Parameter currentUnitLocation: Current mouse location in unit space.
    */
    func didDragOnHorizontalMeter(  sender: TimelineView,
                                    startPixelLocation: CGFloat,
                                    currentPixelLocation: CGFloat,
                                    startUnitLocation: CGFloat,
                                    currentUnitLocation: CGFloat)
    
    /**
     When the mouse clicks somewhere on the graph.
     - Parameter sender: Who sent the event.
     - Parameter currentPixelLocation: Current mouse location in pixel space.
     - Parameter currentUnitLocation: Current mouse location in unit space.
    */
    func didClickOnTimelineGraph( sender: TimelineView,
                                  currentPixelLocation: CGPoint,
                                  currentUnitLocation: CGPoint)
    
    /**
     When the mouse is dragged from the horizontal meter.
     - Parameter sender: Who sent the event.
     - Parameter startPixelLocation: Starting mouse location in pixel space.
     - Parameter currentPixelLocation: Current mouse location in pixel space.
     - Parameter startUnitLocation: Starting mouse location in unit space.
     - Parameter currentUnitLocation: Current mouse location in unit space.
     */
    func didDragOnTimelineGraph(  sender: TimelineView,
                                  startPixelLocation: CGPoint,
                                  currentPixelLocation: CGPoint,
                                  startUnitLocation: CGPoint,
                                  currentUnitLocation: CGPoint)
}
