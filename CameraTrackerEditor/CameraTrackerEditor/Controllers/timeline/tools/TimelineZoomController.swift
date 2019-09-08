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
    private let _zoomMultiplier: CGSize = CGSize(width: 2, height: 2)
    
    /**
     Called when this controller's tool is first selected.
     - Parameter forView: The timeline view.
     */
    override func onStart( forView view: TimelineView ) {
        updateZoomCursor(event: nil, view: view)
    }
    
    /**
     Called when one of the modifier keys (Control, Shift, Option, etc) is
     pressed or released.
     - Parameter forView: The timeline view.
     - Parameter withEvent: The keyboard event.
     */
    override func onFlagsChanged( forView view: TimelineView,
                                  withEvent event: NSEvent) {
        updateZoomCursor(event: event, view: view)
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
        // perform zoom
        let zoomAmount = getZoomMultiplier(
            zoomOut: isOptionDown(event: mouseEvent)
        )
        zoom(
            withView: sender,
            atUnitPosition: CGPoint(
                x: currentUnitLocation,
                y: 0
            ),
            withUnitZoom: CGSize(
                width: zoomAmount.width,
                height: 1
            )
        )
    }
    
    /**
     When a mouse up event occurs somewhere on the vertical unit meter.
     - Parameter sender: Who sent the event.
     - Parameter mouseEvent: The mouse event that was dispatched.
     - Parameter currentPixelLocation: Current mouse location in pixel space.
     - Parameter currentUnitLocation: Current mouse location in unit space.
     */
    override func didMouseUpOnUnitMeter( sender: TimelineView,
                                         mouseEvent: NSEvent,
                                         currentPixelLocation: CGFloat,
                                         currentUnitLocation: CGFloat) {
        // perform zoom
        let zoomAmount = getZoomMultiplier(
            zoomOut: isOptionDown(event: mouseEvent)
        )
        zoom(
            withView: sender,
            atUnitPosition: CGPoint(
                x: 0,
                y: currentUnitLocation
            ),
            withUnitZoom: CGSize(
                width: 1,
                height: zoomAmount.width
            )
        )
    }
    
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
        // perform zoom
        let zoomAmount = getZoomMultiplier(
        zoomOut: isOptionDown(event: mouseEvent)
        )
        zoom(
            withView: sender,
            atUnitPosition: currentUnitLocation,
            withUnitZoom: zoomAmount
        )
    }
    
    /**
     When the mouse enters the timeline view.
     - Parameter sender: Who sent the event.
     - Parameter mouseEvent: The mouse event that was dispatched.
     */
    override func didMouseEnter( sender: TimelineView,
                                 mouseEvent: NSEvent) {
        updateZoomCursor(event: mouseEvent, view: sender)
    }
    
    
    /**
     Returns true if the option key is down.
     - Parameter event: The event where we can check if Option is pressed.
     - Returns: True if Option is pressed. False if not.
    */
    private func isOptionDown(event: NSEvent?) -> Bool {
        return event?.modifierFlags.contains(.option) ?? false
    }
    
    /**
     Sets the appropriate zoom cursor icon.
     - Parameter event: The event used to detect if Option is pressed or not.
    */
    private func updateZoomCursor(event: NSEvent?, view: TimelineView) {
        if isOptionDown(event: event) {
            changeCursor(withCursor: cursorZoomOut, inView: view)
        }
        else {
            changeCursor(withCursor: cursorZoomIn, inView: view)
        }
    }
    
    /**
     Returns the zoom multiplier.
     - Parameter zoomOut: If true, will return zoom out multiplier. If false,
        will return zoom in multiplier.
     - Returns: The zoom multiplier.
    */
    private func getZoomMultiplier(zoomOut: Bool) -> CGSize {
        return zoomOut
            ? CGSize( // zoom out
                width: 1 / _zoomMultiplier.width,
                height: 1 / _zoomMultiplier.height
                )
            : CGSize( // zoom in
                width: _zoomMultiplier.width,
                height: _zoomMultiplier.height
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
