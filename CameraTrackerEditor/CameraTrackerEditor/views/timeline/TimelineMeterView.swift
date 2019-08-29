//
//  TimelineMeter.swift
//  CameraTrackerEditor
//
//  Created by Michael Levesque on 8/27/19.
//  Copyright © 2019 Michael Levesque. All rights reserved.
//

import Cocoa

class TimelineMeterView : NSView {
    // setting for which direction the meter goes
    @IBInspectable var isVertical: Bool = false
    
    // color for teh background
    @IBInspectable var backgroundColor: NSColor = NSColor.darkGray
    @IBInspectable var borderColor: NSColor = NSColor.lightGray
    
    // settings for the ticks
    @IBInspectable var tickColor: NSColor = NSColor.lightGray
    @IBInspectable var tickSize: CGFloat = 10.0
    @IBInspectable var tickWidth: CGFloat = 1.0
    @IBInspectable var tickInterval: CGFloat = 30.0
    
    
    private var m_startUnitPosition: CGFloat
    private var m_unitRange: CGFloat
    
    
    var startUnitPosition: CGFloat {
        get { return m_startUnitPosition }
        set(value) { m_startUnitPosition = value }
    }
    var unitRange: CGFloat {
        get { return m_unitRange }
        set(value) { m_unitRange = value }
    }
    var startPixelPosition: CGFloat {
        get { return m_startUnitPosition * scale }
        set(value) { m_startUnitPosition = value / scale }
    }
    var scale: CGFloat {
        get { return getViewLength() / m_unitRange }
        set(value) { m_unitRange = getViewLength() / value }
    }
    
    
    required init?(coder decoder: NSCoder) {
        m_startUnitPosition = 0.0
        m_unitRange = 1.0
        super.init(coder: decoder)
    }
    
    
    override func draw(_ dirtyRect: NSRect) {
        // get the context
        guard let context = NSGraphicsContext.current?.cgContext else {
            return
        }
        // draw
        drawBackground(context: context)
        drawAllTicks(inContext: context)
    }
    
    private func getViewLength() -> CGFloat {
        return isVertical ? frame.height : frame.width
    }
    
    private func drawBackground(context: CGContext) {
        let rect = CGRect(x: 0.0, y: 0.0, width: frame.width, height: frame.height)
        context.setLineWidth(1.0)
        context.setFillColor(backgroundColor.cgColor)
        context.setStrokeColor(borderColor.cgColor)
        context.addRect(rect)
        context.drawPath(using: .fillStroke)
    }
    
    private func setupContextTransformation(_ context: CGContext) {
        // shift to bottom right if vertical
        if isVertical {
            context.translateBy(x: frame.width, y: 0.0)
            context.rotate(by: CGFloat(Double.pi / 2.0))
        }
        // scale to unit space
        context.scaleBy(x: scale, y: 1.0)
        // translate by units
        context.translateBy(x: -startUnitPosition, y: 0.0)
    }
    
    private func drawAllTicks(inContext context: CGContext) {
        context.saveGState()
        setupContextTransformation(context)
        let endVal = ceil(startUnitPosition + unitRange)
        let interval = tickInterval / scale
        // iterate through all ticks to be drawn
        var pos = floor(startUnitPosition)
        while pos < endVal {
            drawTick(inContext: context, value: pos, adjustedTickSize: tickSize)
            pos = pos + interval
        }
        context.restoreGState()
        context.setLineWidth(tickWidth)
        context.setStrokeColor(tickColor.cgColor)
        context.drawPath(using: .stroke)
    }
    
    func drawTick(inContext context: CGContext, value: CGFloat, adjustedTickSize: CGFloat) {
        let pos = CGPoint(x: value, y: 0.0)
        let end = CGPoint(x: value, y: adjustedTickSize)
        context.move(to: pos)
        context.addLine(to: end)
    }
}
