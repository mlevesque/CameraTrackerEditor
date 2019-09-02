//
//  TimelineMeter.swift
//  CameraTrackerEditor
//
//  Created by Michael Levesque on 8/27/19.
//  Copyright © 2019 Michael Levesque. All rights reserved.
//

import Cocoa

class TimelineMeterView : TimelineViewBase {
    // setting for which direction the meter goes
    @IBInspectable var isVertical: Bool = false
    
    
    var backgroundColor: NSColor = NSColor.darkGray
    var borderColor: NSColor = NSColor.lightGray
    var dividerColor: NSColor = NSColor.white
    
    
    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
    }
    
    
    private func adjustInterval(interval: CGSize) -> CGSize {
        return CGSize(
            width: isVertical ? 0.0 : interval.width,
            height: isVertical ? interval.height : 0.0
        )
    }
    
    override func calculateMinorInterval() -> CGSize {
        let interval = super.calculateMinorInterval()
        return adjustInterval(interval: interval)
    }
    
    override func calculateMajorInterval() -> CGSize {
        let interval = super.calculateMajorInterval()
        return adjustInterval(interval: interval)
    }
    
    override func draw(_ dirtyRect: NSRect) {
        // get the context
        guard let context = NSGraphicsContext.current?.cgContext else {
            return
        }
        // background
        drawBackground(context: context)
        
        // setup transform
        let transform = buildTransform(atStartPos: startUnitPosition, atScale: scale)
        let unitRect = buildUnitRect(fromPixelRect: dirtyRect, withTransform: transform.inverted())
        
        // draw minor ticks
        let minorInterval = calculateMinorInterval()
        let minorIntervalValue = isVertical ? minorInterval.height : minorInterval.width
        if minorIntervalValue > 0.0 {
            let minorUnitRect = buildIntervalAdjustedUnitRect(
                fromUnitRect: unitRect,
                withInterval: minorInterval
            )
            drawTicks(
                toContext: context,
                inUnitRect: minorUnitRect,
                withTransform: transform,
                withInterval: minorInterval,
                useVerticalTicks: !isVertical,
                withTickWidth: tickMinorWidth,
                withTickColor: tickMinorColor.cgColor
            )
        }

        let majorInterval = calculateMajorInterval()
        let majorUnitRect = buildIntervalAdjustedUnitRect(
            fromUnitRect: unitRect,
            withInterval: majorInterval
        )
        drawTicks(
            toContext: context,
            inUnitRect: majorUnitRect,
            withTransform: transform,
            withInterval: majorInterval,
            useVerticalTicks: !isVertical,
            withTickWidth: tickMajorWidth,
            withTickColor: tickMajorColor.cgColor
        )
        
        // draw special tick at zero
        drawZeroTick(
            toContext: context,
            inUnitRect: unitRect,
            withTransform: transform,
            showHorizontal: isVertical,
            showVertical: !isVertical,
            withTickWidth: tickZeroWidth,
            withTickColor: tickZeroColor.cgColor
        )
        
        // draw divider
        drawDivider(context: context)
        
        // draw number values
        let textInterval = calculateTextInterval(
            minorInterval: minorInterval,
            majorInterval: majorInterval
        )
        let textUnitRect = buildIntervalAdjustedUnitRect(
            fromUnitRect: unitRect,
            withInterval: textInterval
        )
        drawTextOverVerticalLines(
            inContext: context,
            inUnitRect: textUnitRect,
            withTransform: transform,
            withInterval: textInterval
        )
    }
    
    private func calculateTextInterval(minorInterval: CGSize, majorInterval: CGSize) -> CGSize {
        // if too small for minor intervals, just use the major interval
        if (isVertical && minorInterval.height == 0.0)
            || (!isVertical && minorInterval.width == 0.0) {
            return majorInterval
        }
            
        // Otherwise, make it appear for every other minor interval
        else {
            return CGSize(
                width: isVertical ? 0.0 : minorInterval.width * 2,
                height: isVertical ? minorInterval.height * 2 : 0.0
            )
        }
    }
    
    private func drawBackground(context: CGContext) {
        let rect = CGRect(x: 0.0, y: 0.0, width: frame.width, height: frame.height)
        context.setLineWidth(1.0)
        context.setFillColor(backgroundColor.cgColor)
        context.setStrokeColor(borderColor.cgColor)
        context.addRect(rect)
        context.drawPath(using: .fillStroke)
    }
    
    private func drawDivider(context: CGContext) {
        // for vertical meter, draw divider on right size of meter
        if isVertical {
            context.move(to: CGPoint(x: frame.width, y: 0.0))
            context.addLine(to: CGPoint(x: frame.width, y: frame.height))
        }
            
        // for horizontal meter, draw divider on bottom of meter
        else {
            context.move(to: CGPoint(x: 0.0, y: 0.0))
            context.addLine(to: CGPoint(x: frame.width, y: 0.0))
        }
        context.setStrokeColor(dividerColor.cgColor)
        context.setLineWidth(1.0)
        context.drawPath(using: .stroke)
    }
    
    private func buildTextPositionMatrix(context: CGContext) -> CGAffineTransform {
        let s = scale
        return CGAffineTransform.identity
            .scaledBy(x: s.width, y: s.height)
            .translatedBy(x: -startUnitPosition.x, y: -startUnitPosition.y)
    }
    
    private func drawTextOverVerticalLines( inContext context: CGContext,
                                            inUnitRect unitRect: CGRect,
                                            withTransform transform: CGAffineTransform,
                                            withInterval interval: CGSize) {
        // pixelPos represents the origin position for the text
        // midPos is a value that should be in the middle of the meter along its short width
        let midPos = isVertical
            ? startUnitPosition.x + unitRange.width / 2
            : startUnitPosition.y + unitRange.height / 2
        var pixelPos = CGPoint(
            x: isVertical ? midPos : unitRect.minX,
            y: isVertical ? unitRect.minY : midPos
            ).applying(transform)
        
        // pixelInterval is the interval amount to traverse in pixel space for each iteration
        let pixelInterval = adjustInterval(interval: interval.applying(transform))
        
        // setup closures for iterations
        var pos = unitRect.origin
        let condition = isVertical
            ? {pos.y < unitRect.maxY}
            : {pos.x < unitRect.maxX}
        let getValue = isVertical
            ? {pos.y}
            : {pos.x}
        
        // iterate along meter from start to end bounds
        while condition() {
            drawValueText(value: getValue(), position: pixelPos)
            pos += interval
            pixelPos += pixelInterval
        }
    }
    
    
    private func drawValueText(value: CGFloat, position: CGPoint) {
        // get the font. If not found, then don't draw text
        guard let font = NSFont(name: "Helvetica Light", size: 10.0) else {
            return
        }
        
        // set up formatting of the number
        let nf = NumberFormatter()
        nf.allowsFloats = true
        nf.maximumFractionDigits = 2
        nf.minimumIntegerDigits = 1
        let text = NSString(string: nf.string(from: NSNumber(value: Float(value)))!)
        
        // set up text attributes
        let attrs: [NSAttributedString.Key:Any] = [
            .font: font,
            .foregroundColor: NSColor.white
        ]
        
        // set up bounding area for drawing the text
        let minFrameSize = min(frame.width, frame.height)
        let size = CGSize(width: minFrameSize, height: minFrameSize)
        let boundingRect = text.boundingRect(
            with: size,
            options: [.usesLineFragmentOrigin],
            attributes: attrs,
            context: nil
        )
        let p = CGPoint(
            x: position.x - boundingRect.size.width / 2,
            y: position.y - boundingRect.size.height / 2
        )
        let textRect = CGRect(origin: p, size: boundingRect.size)
        
        // draw the text
        text.draw(
            with: textRect,
            options: [.usesLineFragmentOrigin],
            attributes: attrs,
            context: nil
        )
    }
}
