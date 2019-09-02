//
//  TimelineViewBase.swift
//  CameraTrackerEditor
//
//  Created by Michael Levesque on 8/30/19.
//  Copyright © 2019 Michael Levesque. All rights reserved.
//

import Cocoa

/**
 Extending CGPoint to give it an operator overload for adding a CGSize to it.
 */
extension CGPoint {
    static func += ( lhs: inout CGPoint, rhs: CGSize) {
        lhs = CGPoint(x: lhs.x + rhs.width, y: lhs.y + rhs.height)
    }
    
    static func + (lhs: CGPoint, rhs: CGSize) -> CGPoint {
        return CGPoint(x: lhs.x + rhs.width, y: lhs.y + rhs.height)
    }
}

class TimelineViewBase: NSView {
    internal typealias TickPlotterClosure = (
        CGContext,  // Context
        CGPoint,    // Unit Start Position
        CGPoint,    // Unit End Position
        CGFloat     // Interval
        ) -> Void
    internal typealias TransformClosure = (CGContext) -> Void
    
    
    // settings for the ticks
    var tickInterval: CGFloat = 30.0
    var tickMinorWidth: CGFloat = 1.0
    var tickMajorWidth: CGFloat = 1.0
    var tickZeroWidth: CGFloat = 1.0
    var tickMinorColor: NSColor = NSColor.lightGray
    var tickMajorColor: NSColor = NSColor.lightGray
    var tickZeroColor: NSColor = NSColor.red
    
    
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

    
    private func calculateStartIntervalPos(interval: CGFloat, start: CGFloat) -> CGFloat {
        if interval == 0.0 {
            return start
        }
        let multiplier = floor(start / interval)
        return interval * multiplier
    }
    
    private func calculateStartIntervalPos(interval: CGSize, start: CGPoint) -> CGPoint {
        return CGPoint(
            x: calculateStartIntervalPos(interval: interval.width, start: start.x),
            y: calculateStartIntervalPos(interval: interval.height, start: start.y)
        )
    }
    
    private func calculateMajorInterval(scale: CGFloat) -> CGFloat {
        let pixelDistancePerHalfUnit: CGFloat = 1.0 * scale
        return ceil(tickInterval / pixelDistancePerHalfUnit)
    }
    
    private func calculateMinorInterval(scale: CGFloat) -> CGFloat {
        let pixelDistancePerHalfUnit: CGFloat = 0.5 * scale
        let multiplier = floor(pixelDistancePerHalfUnit / tickInterval)
        return multiplier == 0.0 ? 0.0 : 0.5 / multiplier
    }
    
    
    internal func calculateMajorInterval() -> CGSize {
        let s = scale
        return CGSize(
            width: calculateMajorInterval(scale: s.width),
            height: calculateMajorInterval(scale: s.height)
        )
    }
    
    internal func calculateMinorInterval() -> CGSize {
        let s = scale
        return CGSize(
            width: calculateMinorInterval(scale: s.width),
            height: calculateMinorInterval(scale: s.height)
        )
    }
    
    internal func buildUnitRect(fromPixelRect pixelRect: CGRect, withTransform transform: CGAffineTransform) -> CGRect {
        // we will be adding a small buffer to the size of the rect to counteract floating point precision error
        // when drawing the last tick or value text
        let adjustedRect = CGRect(
            origin: pixelRect.origin,
            size: CGSize(
                width: pixelRect.size.width + 5.0,
                height: pixelRect.size.height + 5.0
            )
        )
        return adjustedRect.applying(transform)
    }
    
    internal func buildIntervalAdjustedUnitRect( fromUnitRect unitRect: CGRect,
                                                 withInterval interval: CGSize) -> CGRect {
        let origin = calculateStartIntervalPos(interval: interval, start: unitRect.origin)
        return CGRect(
            origin: origin,
            size: CGSize(
                width: unitRect.width + unitRect.minX - origin.x,
                height: unitRect.height + unitRect.minY - origin.y
            )
        )
    }
    
    internal func buildTransform( atStartPos startPos: CGPoint,
                                  atScale scale: CGSize) -> CGAffineTransform {
        return CGAffineTransform.identity
            .scaledBy(x: scale.width, y: scale.height)
            .translatedBy(x: -startPos.x, y: -startPos.y)
    }
    
    internal func drawTicks( toContext context: CGContext,
                             inUnitRect unitRect: CGRect,
                             withTransform transform: CGAffineTransform,
                             withInterval interval: CGSize,
                             useVerticalTicks: Bool,
                             withTickWidth tickWidth: CGFloat,
                             withTickColor tickColor: CGColor) {
        // save state of context before we apply transform
        context.saveGState()
        context.concatenate(transform)
        
        // setup for iterating for each tick
        var pos1 = unitRect.origin
        var pos2 = useVerticalTicks
            ? CGPoint(x: unitRect.minX, y: unitRect.maxY)
            : CGPoint(x: unitRect.maxX, y: unitRect.minY)
        let endPos = unitRect.origin + unitRect.size
        let condition = useVerticalTicks
            ? {pos1.x < endPos.x}
            : {pos1.y < endPos.y}
        
        // plot ticks
        while condition() {
            context.move(to: pos1)
            context.addLine(to: pos2)
            pos1 += interval
            pos2 += interval
        }
        
        // restore state of context to remove transforms before applying
        context.restoreGState()
        context.setLineWidth(tickWidth)
        context.setStrokeColor(tickColor)
        
        // present
        context.drawPath(using: .stroke)
    }
    
    internal func drawZeroTick( toContext context: CGContext,
                                inUnitRect unitRect: CGRect,
                                withTransform transform: CGAffineTransform,
                                showHorizontal: Bool,
                                showVertical: Bool,
                                withTickWidth tickWidth: CGFloat,
                                withTickColor tickColor: CGColor) {
        context.saveGState()
        context.concatenate(transform)
        
        // vertical line
        if showVertical {
            context.move(to: CGPoint(x: 0.0, y: unitRect.minY))
            context.addLine(to: CGPoint(x: 0.0, y: unitRect.maxY))
        }
        
        // horizontal line
        if showHorizontal {
            context.move(to: CGPoint(x: unitRect.minX, y: 0.0))
            context.addLine(to: CGPoint(x: unitRect.maxX, y: 0.0))
        }
        
        context.restoreGState()
        context.setLineWidth(tickWidth)
        context.setStrokeColor(tickColor)
        context.drawPath(using: .stroke)
    }
}
