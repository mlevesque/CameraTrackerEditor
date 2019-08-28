//
//  TimelineGraphView.swift
//  CameraTrackerEditor
//
//  Created by Michael Levesque on 8/28/19.
//  Copyright © 2019 Michael Levesque. All rights reserved.
//

import Cocoa

class TimelineGraphView : NSView {
    @IBInspectable var xPosColor: NSColor = NSColor.red
    @IBInspectable var yPosColor: NSColor = NSColor.green
    @IBInspectable var zPosColor: NSColor = NSColor.blue
    @IBInspectable var xRotColor: NSColor = NSColor.systemPink
    @IBInspectable var yRotColor: NSColor = NSColor.yellow
    @IBInspectable var zRotColor: NSColor = NSColor.purple
    @IBInspectable var lineWidth: CGFloat = 2.0
    
    @IBInspectable var tickColor: NSColor = NSColor.darkGray
    @IBInspectable var tickWidth: CGFloat = 1.0
    @IBInspectable var tickInterval: CGFloat = 30.0
    
    
    private var m_trackingData: TrackingData?
    private var m_startUnitPosition: CGPoint
    private var m_unitRange: CGPoint
    
    
    var startUnitPositionX: CGFloat {
        get { return m_startUnitPosition.x }
        set(value) { m_startUnitPosition.x = value }
    }
    var startUnitPositionY: CGFloat {
        get { return m_startUnitPosition.y }
        set(value) { m_startUnitPosition.y = value }
    }
    var unitRangeX: CGFloat {
        get { return m_unitRange.x }
        set(value) { m_unitRange.x = value }
    }
    var unitRangeY: CGFloat {
        get { return m_unitRange.y }
        set(value) { m_unitRange.y = value }
    }
    var startPixelPositionX: CGFloat {
        get { return m_startUnitPosition.x * scaleX }
        set(value) { m_startUnitPosition.x = value / scaleX }
    }
    var startPixelPositionY: CGFloat {
        get { return m_startUnitPosition.y * scaleY }
        set(value) { m_startUnitPosition.y = value / scaleY }
    }
    var scaleX: CGFloat {
        get { return frame.width / m_unitRange.x }
        set(value) { m_unitRange.x = frame.width / value }
    }
    var scaleY: CGFloat {
        get { return frame.width / m_unitRange.y }
        set(value) { m_unitRange.y = frame.height / value }
    }
    
    
    required init?(coder decoder: NSCoder) {
        m_startUnitPosition = CGPoint(x: 0.0, y: 0.0)
        m_unitRange = CGPoint(x: 1.0, y: 1.0)
        super.init(coder: decoder)
    }
    
    
    func setTrackingData(data: TrackingData) {
        m_trackingData = data
        setNeedsDisplay(frame)
    }
    
    
    override func draw(_ dirtyRect: NSRect) {
        // get context
        guard let context = NSGraphicsContext.current?.cgContext else {
            return
        }
        
        // set up transform
        setupContextTransform(context)
        
        // draw ticks
        drawTicks(inContext: context)
    }
    
    private func setupContextTransform(_ context: CGContext) {
        // scale to unit space
        context.scaleBy(x: scaleX, y: scaleY)
        // translate by units
        context.translateBy(x: -startUnitPositionX, y: -startUnitPositionY)
    }
    
    private func calculateTickInterval() -> CGPoint {
        return CGPoint(
            x: tickInterval / scaleX,
            y: tickInterval / scaleY
        )
    }
    
    private func drawTicks(inContext context: CGContext) {
        let start = CGPoint(
            x: floor(m_startUnitPosition.x),
            y: floor(m_startUnitPosition.y)
        )
        let end = CGPoint(
            x: ceil(m_startUnitPosition.x + m_unitRange.x),
            y: ceil(m_startUnitPosition.y + m_unitRange.y)
        )
        let interval = CGPoint(
            x: tickInterval / scaleX,
            y: tickInterval / scaleY
        )
        
        // setup drawing
        context.setLineWidth(tickWidth / scaleX)
        context.setStrokeColor(tickColor.cgColor)
        
        // draw vertical ticks
        var pos = start.x
        while pos < end.x {
            context.move(to: CGPoint(x: pos, y: start.y))
            context.addLine(to: CGPoint(x: pos, y: end.y))
            pos = pos + interval.x
        }
        
        // draw horizontal ticks
        pos = start.y
        while pos < end.y {
            context.move(to: CGPoint(x: start.x, y: pos))
            context.addLine(to: CGPoint(x: end.x, y: pos))
            pos = pos + interval.y
        }
        
        // present
        context.drawPath(using: .stroke)
    }
}
