//
//  TimelineViewController+Scale&Position.swift
//  CameraTrackerEditor
//
//  Created by Michael Levesque on 9/5/19.
//  Copyright © 2019 Michael Levesque. All rights reserved.
//

import Cocoa

extension TimelineViewController {
    /**
     Scales the time (x axis) in timeline based on the percent value, then
     updates the UI.
     - Parameter percentValue: The percent value to scale the timeline to.
    */
    func scaleTimeByPercent(_ percentValue: Double) {
        let scale = 100 / percentValue
        timelineView?.scale = CGSize(
            width: CGFloat(scale),
            height: timelineView.scale.height
        )
        updateSliderUI()
    }
    
    /**
     Scales the time (x axis) in timeline based on the given duration in
     seconds, then updates the UI.
     - Parameter duration: The duration of time to scale to, in seconds.
    */
    func scaleTimeByDuration(_ duration: Double) {
        timelineView?.unitLength = CGSize(
            width: CGFloat(duration),
            height: timelineView.unitLength.height
        )
        updateSliderUI()
    }
    
    /**
     Scales the units (y axis) in timeline based on the percent value, then
     updates the UI.
     - Parameter percentValue: The percent value to scale the timeline to.
     */
    func scaleUnitsByPercent(_ percentValue: Double) {
        let scale = 100 / percentValue
        timelineView?.scale = CGSize(
            width: timelineView.scale.width,
            height: CGFloat(scale)
        )
        updateSliderUI()
    }
    
    /**
     Scales the units (y axis) in timeline based on the given duration in
     seconds, then updates the UI.
     - Parameter duration: The unit length to scale to.
    */
    func scaleUnitsByLength(_ length: Double) {
        timelineView?.unitLength = CGSize(
            width: timelineView.unitLength.height,
            height: CGFloat(length)
        )
        updateSliderUI()
    }
    
    /**
     Positions the timeline to the given position, in units.
     - Parameter inUnits: Position in units.
    */
    func positionTimeline(inUnits pos: CGPoint) {
        timelineView?.startUnitPosition = pos
    }
    
    /**
     Positions the timeline to the given position, in pixels.
     - Parameter inPixels: Position in pixels.
    */
    func positionTimeline(inPixels pos: CGPoint) {
        timelineView?.startPixelPosition = pos
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
        var pos = timelineView?.startUnitPosition ?? CGPoint(x: 0, y: -5)
        
        // adjust vertically
        if vertically {
            let range = calculateVerticalBounds()
            pos.y = CGFloat(range.start)
            scaleUnitsByLength(range.end - range.start)
        }
        
        // adjust horizontally
        if horizontally {
            pos.x = 0
            if let duration = _trackingData?.duration {
                scaleTimeByDuration(duration)
            }
            else {
                scaleTimeByDuration(10)
            }
        }
        positionTimeline(inUnits: pos)
        redraw()
    }
    
    
    /**
     Calculates the vertical bounds of all data components in the tracking data
     that are marked to be shown and returns the range.
     - Returns: The range of the minimal and maximal data values from the
     tracking data.
     */
    private func calculateVerticalBounds() -> (start: Double, end: Double) {
        guard let data = _trackingData else {
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
        return (start: Double(minVal), end: Double(maxVal))
    }
}
