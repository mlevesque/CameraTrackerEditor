//
//  TimelineViewController.swift
//  CameraTrackerEditor
//
//  Created by Michael Levesque on 8/28/19.
//  Copyright © 2019 Michael Levesque. All rights reserved.
//

import Cocoa

class TimelineViewController : NSViewController {
    
    @IBInspectable var meterBackgroundColor: NSColor = NSColor.darkGray
    @IBInspectable var meterBorderColor: NSColor = NSColor.lightGray
    @IBInspectable var meterDividerColor: NSColor = NSColor.white
    
    @IBInspectable var tickInterval: CGFloat = 30.0
    
    @IBInspectable var tMinorWidth: CGFloat = 1.0
    @IBInspectable var tMajorWidth: CGFloat = 1.0
    @IBInspectable var tZeroWidth: CGFloat = 1.0
    
    @IBInspectable var tMinorColor: NSColor = NSColor.lightGray
    @IBInspectable var tMajorColor: NSColor = NSColor.lightGray
    @IBInspectable var tZeroColor: NSColor = NSColor.red
    @IBInspectable var tMMinorColor: NSColor = NSColor.lightGray
    @IBInspectable var tMMajorColor: NSColor = NSColor.lightGray
    @IBInspectable var tMZeroColor: NSColor = NSColor.red
    
    @IBInspectable var xPosColor: NSColor = NSColor.red
    @IBInspectable var yPosColor: NSColor = NSColor.green
    @IBInspectable var zPosColor: NSColor = NSColor.blue
    @IBInspectable var xRotColor: NSColor = NSColor.systemPink
    @IBInspectable var yRotColor: NSColor = NSColor.yellow
    @IBInspectable var zRotColor: NSColor = NSColor.purple
    @IBInspectable var lineWidth: CGFloat = 2.0
    
    
    private var m_trackingData: TrackingData?
    
    private var m_showPosX: Bool = true
    private var m_showPosY: Bool = true
    private var m_showPosZ: Bool = true
    private var m_showRotX: Bool = true
    private var m_showRotY: Bool = true
    private var m_showRotZ: Bool = true
    
    @IBOutlet var horizontalMeter: TimelineMeterView!
    @IBOutlet var verticalMeter: TimelineMeterView!
    @IBOutlet var graph: TimelineGraphView!
    
    
    override func viewDidLoad() {
        graph.setTrackingData(data: m_trackingData)
        
        // set attributes to sub views
        let subviews = [graph, horizontalMeter, verticalMeter]
        for v in subviews {
            v?.tickInterval = tickInterval
            v?.tickMinorWidth = tMinorWidth
            v?.tickMajorWidth = tMajorWidth
            v?.tickZeroWidth = tZeroWidth
        }
        let meters = [horizontalMeter, verticalMeter]
        for v in meters {
            v?.backgroundColor = meterBackgroundColor
            v?.borderColor = meterBorderColor
            v?.dividerColor = meterDividerColor
            v?.tickMinorColor = tMMinorColor
            v?.tickMajorColor = tMMajorColor
            v?.tickZeroColor = tMZeroColor
        }
        graph.tickMinorColor = tMinorColor
        graph.tickMajorColor = tMajorColor
        graph.tickZeroColor = tZeroColor
        graph.xPosColor = xPosColor
        graph.yPosColor = yPosColor
        graph.zPosColor = zPosColor
        graph.xRotColor = xRotColor
        graph.yRotColor = yRotColor
        graph.zRotColor = zRotColor
        graph.lineWidth = lineWidth
        
        super.viewDidLoad()
    }
    
    func setTrackingData(data: TrackingData?) {
        m_trackingData = data
        if graph != nil {
            graph.setTrackingData(data: m_trackingData)
        }
        scaleToFit()
    }
    
    func redraw() {
        if let hm = horizontalMeter {
            hm.setNeedsDisplay(hm.frame.offsetBy(dx: -hm.frame.minX, dy: -hm.frame.minY))
        }
        if let vm = verticalMeter {
            vm.setNeedsDisplay(vm.frame.offsetBy(dx: -vm.frame.minX, dy: -vm.frame.minY))
        }
        if let g = graph {
            g.setNeedsDisplay(g.frame.offsetBy(dx: -g.frame.minX, dy: -g.frame.minY))
        }
    }
    
    func scaleToFit(vertically: Bool = true, horizontally: Bool = true) {
        // get current position and scale
        var startPos = graph?.startUnitPosition ?? CGPoint(x: 0.0, y: 0.0)
        var unitRange = graph?.unitRange ?? CGSize(width: 1.0, height: 1.0)
        
        // adjust vertically
        if vertically {
            let range = calculateVerticalBounds()
            startPos.y = range.start
            unitRange.height = range.end - range.start
        }
        
        // adjust horizontally
        if horizontally {
            startPos.x = 0.0
            if let duration = m_trackingData?.duration {
                unitRange.width = CGFloat(duration)
            }
            else {
                unitRange.width = 1.0
            }
        }
        
        // add adjustments to views
        if let vm = verticalMeter {
            vm.startUnitPosition = startPos
            vm.unitRange = unitRange
        }
        if let hm = horizontalMeter {
            hm.startUnitPosition = startPos
            hm.unitRange = unitRange
        }
        if let g = graph {
            g.startUnitPosition = startPos
            g.unitRange = unitRange
        }
        
        // refresh draw
        redraw()
    }
    
    
    private func calculateVerticalBounds() -> (start: CGFloat, end: CGFloat) {
        guard let data = m_trackingData else {
            return (start: -0.5, end: 0.5)
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
            minVal = -0.5
            maxVal = 0.5
        }
        return (start: minVal, end: maxVal)
    }
}
