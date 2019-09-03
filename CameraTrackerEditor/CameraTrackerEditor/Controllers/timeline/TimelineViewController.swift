//
//  TimelineViewController.swift
//  CameraTrackerEditor
//
//  Created by Michael Levesque on 8/28/19.
//  Copyright © 2019 Michael Levesque. All rights reserved.
//

import Cocoa

class TimelineViewController : NSViewController {
    /** The tracking data to render in the timeline. */
    private var m_trackingData: TrackingData?
    
    /** reference to the timeline view */
    @IBOutlet var timelineView: TimelineView!
    
    
    /**
     When the view loads. Set it up for rendering.
    */
    override func viewDidLoad() {
        // setup the view
        timelineView.trackingData = m_trackingData
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
        m_trackingData = data
        if timelineView != nil {
            timelineView.trackingData = m_trackingData
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
     Uses the tracking data and what data points are marked to be shown and
     scales the timeline so that all that data fits without scrolling. If
     there is no tracking data, then this defaults the timeline to default
     values.
     - Parameter vertically: Changes the x scale to fit the entire duration
        of the tracking data. This is true by default.
     - Parameter horizontally: Changes the y scale to fit all visible tracking
        data. This is true by default.
    */
    func scaleToFit(vertically: Bool = true, horizontally: Bool = true) {
        // get current position and scale
        var startPos = timelineView?.startUnitPosition
            ?? CGPoint(x: 0, y: -5)
        var unitDimensions = timelineView?.unitDimensions
            ?? CGSize(width: 10, height: 10)
        
        // adjust vertically
        if vertically {
            let range = calculateVerticalBounds()
            startPos.y = range.start
            unitDimensions.height = range.end - range.start
        }
        
        // adjust horizontally
        if horizontally {
            startPos.x = 0
            if let duration = m_trackingData?.duration {
                unitDimensions.width = CGFloat(duration)
            }
            else {
                unitDimensions.width = 10
            }
        }
        
        // add adjustments to view
        timelineView?.startUnitPosition = startPos
        timelineView?.unitDimensions = unitDimensions
        
        // refresh draw
        redraw()
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
    
    
    /**
     Calculates the vertical bounds of all data components in the tracking data
     that are marked to be shown and returns the range.
     - Returns: The range of the minimal and maximal data values from the
        tracking data.
    */
    private func calculateVerticalBounds() -> (start: CGFloat, end: CGFloat) {
        guard let data = m_trackingData else {
            return (start: -5, end: 5)
        }
        
        // get min max values of all components that will be drawn
        var minVal = CGFloat.greatestFiniteMagnitude
        var maxVal = -CGFloat.greatestFiniteMagnitude
        var valuesAreSet = false
        if timelineView.showPositionX {
            minVal = CGFloat(min(Float(minVal), data.minPositionValues.x))
            maxVal = CGFloat(max(Float(maxVal), data.maxPositionValues.x))
            valuesAreSet = true
        }
        if timelineView.showPositionY {
            minVal = CGFloat(min(Float(minVal), data.minPositionValues.y))
            maxVal = CGFloat(max(Float(maxVal), data.maxPositionValues.y))
            valuesAreSet = true
        }
        if timelineView.showPositionZ {
            minVal = CGFloat(min(Float(minVal), data.minPositionValues.z))
            maxVal = CGFloat(max(Float(maxVal), data.maxPositionValues.z))
            valuesAreSet = true
        }
        if timelineView.showRotationX {
            minVal = CGFloat(min(Float(minVal), data.minRotationValues.x))
            maxVal = CGFloat(max(Float(maxVal), data.maxRotationValues.x))
            valuesAreSet = true
        }
        if timelineView.showRotationY {
            minVal = CGFloat(min(Float(minVal), data.minRotationValues.y))
            maxVal = CGFloat(max(Float(maxVal), data.maxRotationValues.y))
            valuesAreSet = true
        }
        if timelineView.showRotationZ {
            minVal = CGFloat(min(Float(minVal), data.minRotationValues.z))
            maxVal = CGFloat(max(Float(maxVal), data.maxRotationValues.z))
            valuesAreSet = true
        }
        
        // if nothing is being shown, then return default values
        if !valuesAreSet {
            minVal = -5
            maxVal = 5
        }
        return (start: minVal, end: maxVal)
    }
}
