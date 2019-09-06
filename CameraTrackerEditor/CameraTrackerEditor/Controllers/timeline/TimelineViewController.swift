//
//  TimelineViewController.swift
//  CameraTrackerEditor
//
//  Created by Michael Levesque on 8/28/19.
//  Copyright © 2019 Michael Levesque. All rights reserved.
//

import Cocoa

class TimelineViewController : NSViewController {
    /** Reprsents the scale multiplier for the scale along the x axis of the
        timeline. Essentailly, this is like the number of pixel distance for
        one second, and when one second is displayed with this distance, then
        the user scale is 100%. */
    @IBInspectable var userTimeScale: Double = 75
    
    
    /** The tracking data to render in the timeline. */
    internal var _trackingData: TrackingData?
    
    
    /** reference to the timeline view */
    @IBOutlet var timelineView: TimelineView!
    /** reference to the zoom slider for time. */
    @IBOutlet var zoomTimeSlider: NSSlider!
    /** reference to the label next to the zoom slider for time. */
    @IBOutlet var zoomTimeLabel: NSTextField!
    
    
    /**
     When the view loads. Set it up for rendering.
    */
    override func viewDidLoad() {
        // setup the view
        timelineView.trackingData = _trackingData
        timelineView.updateTransform()
        timelineView.delegate = self
        super.viewDidLoad()
    }
    
    /**
     Sets the tracking data to the given one. This will also pass it to the
     view for rendering and will scale the timeline to fit the data.
     - Parameter data: The data to render in the timeline.
    */
    func setTrackingData(data: TrackingData?) {
        _trackingData = data
        if timelineView != nil {
            timelineView.trackingData = _trackingData
        }
        scaleToFit()
    }
    
    /**
     Makes the timeline redraw.
    */
    func redraw() {
        if let v = timelineView {
            v.setNeedsDisplay(
                v.frame.offsetBy(dx: -v.frame.minX, dy: -v.frame.minY)
            )
        }
    }
    
    /**
     Places the playhead in the timeline to the given position in pixel space
     and this makes the timeline redraw.
     - Parameter atPixelLocation: The location to place the playhead, in pixel
        coordinates.
     */
    func positionPlayhead(atPixelLocation pixelLocation: CGFloat) {
        timelineView.playheadPixelPosition = pixelLocation
        redraw()
    }
    
    /**
     Places the playhead in the timeline to the given position in pixel space
     and this makes the timeline redraw.
     - Parameter atPixelLocation: The location to place the playhead, in pixel
        coordinates.
     */
    func positionPlayhead(atUnitLocation unitLocation: CGFloat) {
        timelineView.playheadUnitPosition = unitLocation
        redraw()
    }
}
