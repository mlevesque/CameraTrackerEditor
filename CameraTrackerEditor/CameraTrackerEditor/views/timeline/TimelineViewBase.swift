//
//  TimelineViewBase.swift
//  CameraTrackerEditor
//
//  Created by Michael Levesque on 8/30/19.
//  Copyright © 2019 Michael Levesque. All rights reserved.
//

import Cocoa

class TimelineViewBase: NSView {
    internal typealias TickPlotterClosure = (
        CGContext,  // Context
        CGPoint,    // Unit Start Position
        CGPoint,    // Unit End Position
        CGFloat     // Interval
        ) -> Void
    
    
    // settings for the ticks
    @IBInspectable var tickInterval: CGFloat = 30.0
    @IBInspectable var tickMinorWidth: CGFloat = 1.0
    @IBInspectable var tickMajorWidth: CGFloat = 1.0
    @IBInspectable var tickZeroWidth: CGFloat = 1.0
    @IBInspectable var tickMinorColor: NSColor = NSColor.lightGray
    @IBInspectable var tickMajorColor: NSColor = NSColor.lightGray
    @IBInspectable var tickZeroColor: NSColor = NSColor.red
    
    
    private var m_startUnitPosition: CGPoint
    private var m_unitRange: CGSize
    
    
    var startUnitPosition: CGPoint {
        get { return m_startUnitPosition }
        set(value) { m_startUnitPosition = value }
    }
    var unitRange: CGSize {
        get { return m_unitRange }
        set(value) { m_unitRange = value }
    }
    var endUnitPosition: CGPoint {
        get {
            return CGPoint(
                x: m_startUnitPosition.x + m_unitRange.width,
                y: m_startUnitPosition.y + m_unitRange.height
            )
        }
        set(value) {
            // make sure that the start position is not larger than given value
            // if it is, then adjust start position
            if value.x < m_startUnitPosition.x {
                m_startUnitPosition.x = value.x
            }
            if value.y < m_startUnitPosition.y {
                m_startUnitPosition.y = value.y
            }
            m_unitRange.width = value.x - m_startUnitPosition.x
            m_unitRange.height = value.y - m_startUnitPosition.y
        }
    }
    var startPixelPosition: CGPoint {
        get {
            let s = scale
            return CGPoint(x: m_startUnitPosition.x * s.width, y: m_startUnitPosition.y * s.height)
        }
        set(value) {
            let s = scale
            m_startUnitPosition = CGPoint(x: value.x / s.width, y: value.y / s.height)
        }
    }
    var scale: CGSize {
        get {
            return CGSize(
                width: frame.width / m_unitRange.width,
                height: frame.height / m_unitRange.height
            )
        }
        set(value) {
            m_unitRange = CGSize(
                width: frame.width / value.width,
                height: frame.height / value.height
            )
        }
    }
    
    
    required init?(coder decoder: NSCoder) {
        m_startUnitPosition = CGPoint(x: 0.0, y: -5.0)
        m_unitRange = CGSize(width: 10.0, height: 10.0)
        super.init(coder: decoder)
    }

    
    internal func calculateMajorInterval(scale: CGFloat) -> CGFloat {
        let pixelDistancePerHalfUnit: CGFloat = 1.0 * scale
        return ceil(tickInterval / pixelDistancePerHalfUnit)
    }
    
    internal func calculateMajorInterval() -> CGSize {
        let s = scale
        return CGSize(
            width: calculateMajorInterval(scale: s.width),
            height: calculateMajorInterval(scale: s.height)
        )
    }
    
    internal func calculateMinorInterval(scale: CGFloat) -> CGFloat {
        let pixelDistancePerHalfUnit: CGFloat = 0.5 * scale
        let multiplier = floor(pixelDistancePerHalfUnit / tickInterval)
        return multiplier == 0.0 ? 0.0 : 0.5 / multiplier
    }
    
    internal func calculateMinorInterval() -> CGSize {
        let s = scale
        return CGSize(
            width: calculateMinorInterval(scale: s.width),
            height: calculateMinorInterval(scale: s.height)
        )
    }
    
    internal func calculateStartIntervalPos(interval: CGFloat, start: CGFloat) -> CGFloat {
        if interval == 0.0 {
            return 0.0
        }
        let multiplier = floor(start / interval)
        return interval * multiplier
    }
    
    internal func applyTransforms( toContext context: CGContext,
                                   atStartPos startPos: CGPoint,
                                   atScale scale: CGSize) {
        context.scaleBy(x: scale.width, y: scale.height)
        context.translateBy(x: -startPos.x, y: -startPos.y)
    }
    
    internal func buildUnitRect( fromPixelPosition pixelPos: CGPoint,
                                 fromPixelRange pixelRange: CGSize,
                                 withTransform transform: CGAffineTransform) -> CGRect {
        let transformedStart = pixelPos.applying(transform)
        let transformedEnd = CGPoint(
            x: pixelPos.x + pixelRange.width * 2,
            y: pixelPos.y + pixelRange.height * 2
        ).applying(transform)
        let size = CGSize(
            width: transformedEnd.x - transformedStart.x,
            height: transformedEnd.y - transformedStart.y
        )
        return CGRect(origin: transformedStart, size: size)
    }
    
    internal func drawTicks( toContext context: CGContext,
                             inPixelRect pixelRect: CGRect,
                             atUnitStartPos unitStartPos: CGPoint,
                             atScale scale: CGSize,
                             withInterval interval: CGFloat,
                             usingPlottingClosure plotClosure: TickPlotterClosure,
                             withTickWidth tickWidth: CGFloat,
                             withTickColor tickColor: CGColor) {
        // save state of context before we apply transform
        context.saveGState()
        applyTransforms(
            toContext: context,
            atStartPos: unitStartPos,
            atScale: scale
        )
        
        // convert pixel rect to unit rect and determine
        let unitRect = buildUnitRect(
            fromPixelPosition: pixelRect.origin,
            fromPixelRange: pixelRect.size,
            withTransform: context.ctm.inverted()
        )
        
        // plot lines
        plotClosure(
            context,
            unitRect.origin,
            CGPoint(x: unitRect.maxX, y: unitRect.maxY),
            interval
        )
        
        // restore state of context to remove transforms before applying
        context.restoreGState()
        context.setLineWidth(tickWidth)
        context.setStrokeColor(tickColor)
        
        // present
        context.drawPath(using: .stroke)
    }
    
    internal func plotHorizontalLines( inContext context: CGContext,
                                       fromStartPos startPos: CGPoint,
                                       toEndPos endPos: CGPoint,
                                       withInterval interval: CGFloat) {
        var pos = calculateStartIntervalPos(interval: interval, start: startPos.y)
        while pos < endPos.y {
            context.move(to: CGPoint(x: startPos.x, y: pos))
            context.addLine(to: CGPoint(x: endPos.x, y: pos))
            pos += interval
        }
    }
    
    internal func plotVerticalLines( inContext context: CGContext,
                                     fromStartPos startPos: CGPoint,
                                     toEndPos endPos: CGPoint,
                                     withInterval interval: CGFloat) {
        var pos = calculateStartIntervalPos(interval: interval, start: startPos.x)
        while pos < endPos.x {
            context.move(to: CGPoint(x: pos, y: startPos.y))
            context.addLine(to: CGPoint(x: pos, y: endPos.y))
            pos += interval
        }
    }
    
    internal func drawZeroTick( toContext context: CGContext,
                                fromStartPos startPos: CGPoint,
                                toEndPos endPos: CGPoint,
                                atScale scale: CGSize,
                                showHorizontal: Bool,
                                showVertical: Bool,
                                withTickWidth tickWidth: CGFloat,
                                withTickColor tickColor: CGColor) {
        context.saveGState()
        applyTransforms(toContext: context, atStartPos: startPos, atScale: scale)
        
        // vertical line
        if showVertical {
            context.move(to: CGPoint(x: 0.0, y: startPos.y))
            context.addLine(to: CGPoint(x: 0.0, y: endPos.y))
        }
        
        // horizontal line
        if showHorizontal {
            context.move(to: CGPoint(x: startPos.x, y: 0.0))
            context.addLine(to: CGPoint(x: endPos.x, y: 0.0))
        }
        
        context.restoreGState()
        context.setLineWidth(tickWidth)
        context.setStrokeColor(tickColor)
        context.drawPath(using: .stroke)
    }
}
