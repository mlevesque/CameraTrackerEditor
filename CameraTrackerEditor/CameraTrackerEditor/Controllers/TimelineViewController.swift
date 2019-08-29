//
//  TimelineViewController.swift
//  CameraTrackerEditor
//
//  Created by Michael Levesque on 8/28/19.
//  Copyright © 2019 Michael Levesque. All rights reserved.
//

import Cocoa

class TimelineViewController : NSViewController {
    private var m_trackingData: TrackingData?
    
    private var m_showPosX: Bool = true
    private var m_showPosY: Bool = true
    private var m_showPosZ: Bool = true
    private var m_showRotX: Bool = true
    private var m_showRotY: Bool = true
    private var m_showRotZ: Bool = true
    
    @IBOutlet weak var horizontalMeter: TimelineMeterView!
    @IBOutlet weak var verticalMeter: TimelineMeterView!
    @IBOutlet weak var graph: TimelineGraphView!
    
    
    override func viewDidLoad() {
        graph.setTrackingData(data: m_trackingData)
        super.viewDidLoad()
    }
    
    func setTrackingData(data: TrackingData?) {
        m_trackingData = data
        if graph != nil {
            graph.setTrackingData(data: m_trackingData)
        }
    }
    
    func redraw() {
        horizontalMeter.setNeedsDisplay(horizontalMeter.frame)
        verticalMeter.setNeedsDisplay(verticalMeter.frame)
        graph.setNeedsDisplay(graph.frame)
    }
    
    func scaleToFit(vertically: Bool = true, horizontally: Bool = true) {
        // adjust vertically
        if vertically {
            let range = calculateVerticalBounds()
            verticalMeter.startUnitPosition = range.start
            graph.startUnitPositionY = range.start
            verticalMeter.unitRange = range.end - range.start
            graph.unitRangeY = range.end - range.start
        }
        
        // adjust horizontally
        if horizontally {
            horizontalMeter.startUnitPosition = 0.0
            graph.startUnitPositionX = 0.0
            if let data = m_trackingData {
                horizontalMeter.unitRange = CGFloat(data.duration)
                graph.unitRangeX = CGFloat(data.duration)
            }
            else {
                horizontalMeter.unitRange = 1.0
                graph.unitRangeX = 1.0
            }
        }
        
        // refresh draw
        redraw()
    }
    
    
    private func calculateVerticalBounds() -> (start: CGFloat, end: CGFloat) {
        guard let data = m_trackingData else {
            return (start: 0.0, end: 1.0)
        }
        
        // get min max values of all components that will be drawn
        var minVal = CGFloat.greatestFiniteMagnitude
        var maxVal = -CGFloat.greatestFiniteMagnitude
        var valuesAreSet = false
        if m_showPosX {
            minVal = CGFloat(min(Float(minVal), data.minPositionValues.x))
            maxVal = CGFloat(max(Float(maxVal), data.maxPositionValues.x))
            valuesAreSet = true
        }
        if m_showPosY {
            minVal = CGFloat(min(Float(minVal), data.minPositionValues.y))
            maxVal = CGFloat(max(Float(maxVal), data.maxPositionValues.y))
            valuesAreSet = true
        }
        if m_showPosZ {
            minVal = CGFloat(min(Float(minVal), data.minPositionValues.z))
            maxVal = CGFloat(max(Float(maxVal), data.maxPositionValues.z))
            valuesAreSet = true
        }
        if m_showRotX {
            minVal = CGFloat(min(Float(minVal), data.minRotationValues.x))
            maxVal = CGFloat(max(Float(maxVal), data.maxRotationValues.x))
            valuesAreSet = true
        }
        if m_showRotY {
            minVal = CGFloat(min(Float(minVal), data.minRotationValues.y))
            maxVal = CGFloat(max(Float(maxVal), data.maxRotationValues.y))
            valuesAreSet = true
        }
        if m_showRotZ {
            minVal = CGFloat(min(Float(minVal), data.minRotationValues.z))
            maxVal = CGFloat(max(Float(maxVal), data.maxRotationValues.z))
            valuesAreSet = true
        }
        
        // if nothing is being shown, then return default values
        if !valuesAreSet {
            minVal = 0.0
            maxVal = 1.0
        }
        return (start: minVal, end: maxVal)
    }
}
