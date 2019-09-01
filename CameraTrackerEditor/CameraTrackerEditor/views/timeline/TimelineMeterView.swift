//
//  TimelineMeter.swift
//  CameraTrackerEditor
//
//  Created by Michael Levesque on 8/27/19.
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
}

class TimelineMeterView : TimelineViewBase {
    // setting for which direction the meter goes
    @IBInspectable var isVertical: Bool = false
    
    
    var backgroundColor: NSColor = NSColor.darkGray
    var borderColor: NSColor = NSColor.lightGray
    var dividerColor: NSColor = NSColor.white
    
    
    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
    }
    
    
    override func draw(_ dirtyRect: NSRect) {
        // get the context
        guard let context = NSGraphicsContext.current?.cgContext else {
            return
        }
        // background
        drawBackground(context: context)
        
        // draw minor ticks
        let s = scale
        let minorInterval = calculateMinorInterval()
        let minorIntervalValue = isVertical ? minorInterval.height : minorInterval.width
        let plotClosure = isVertical
            ? plotHorizontalLines(inContext:fromStartPos:toEndPos:withInterval:)
            : plotVerticalLines(inContext:fromStartPos:toEndPos:withInterval:)
        if minorIntervalValue > 0.0 {
            drawTicks(
                toContext: context,
                inPixelRect: dirtyRect,
                atUnitStartPos: startUnitPosition,
                atScale: s,
                withInterval: minorIntervalValue,
                usingPlottingClosure: plotClosure,
                withTickWidth: tickMinorWidth,
                withTickColor: tickMinorColor.cgColor
            )
        }

        let majorInterval = calculateMajorInterval()
        let majorIntervalValue = isVertical ? majorInterval.height : majorInterval.width
        drawTicks(
            toContext: context,
            inPixelRect: dirtyRect,
            atUnitStartPos: startUnitPosition,
            atScale: s,
            withInterval: majorIntervalValue,
            usingPlottingClosure: plotClosure,
            withTickWidth: tickMajorWidth,
            withTickColor: tickMajorColor.cgColor
        )
        
        // draw special tick at zero
        drawZeroTick(
            toContext: context,
            fromStartPos: startUnitPosition,
            toEndPos: CGPoint(
                x: startUnitPosition.x + unitRange.width,
                y: startUnitPosition.y + unitRange.height
            ),
            atScale: s,
            showHorizontal: isVertical,
            showVertical: !isVertical,
            withTickWidth: tickZeroWidth,
            withTickColor: tickZeroColor.cgColor
        )
        
        // draw divider
        drawDivider(context: context)
        
        // draw number values
        let textInterval = calculateTextInterval(minorInterval: minorIntervalValue, majorInterval: majorIntervalValue)
        drawTextOverVerticalLines(inContext: context, inPixelRect: dirtyRect, withInterval: textInterval)
    }
    
    private func calculateTextInterval(minorInterval: CGFloat, majorInterval: CGFloat) -> CGFloat {
        // if too small for minor intervals, just use the major interval
        if minorInterval == 0.0 {
            return majorInterval
        }
            
        // Otherwise, make it appear for every other minor interval
        else {
            return minorInterval * 2
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
                                    inPixelRect pixelRect: CGRect,
                                    withInterval interval: CGFloat) {
        // build matrix and convert pixel rect to unit rect
        // we will use the bounds of unit rect for iterating over
        let mat = buildTextPositionMatrix(context: context)
        let unitRect = buildUnitRect(
            fromPixelPosition: pixelRect.origin,
            fromPixelRange: pixelRect.size,
            withTransform: mat.inverted()
        )
        
        // get starting value position
        // this also serves as the value to display in text
        var value = calculateStartIntervalPos(
            interval: interval,
            start: isVertical ? unitRect.minY : unitRect.minX
        )
        
        // pixelPos represents the origin position for the text
        // midPos is a value that should be in the middle of the meter along its short width
        let midPos = isVertical
            ? startUnitPosition.x + unitRange.width / 2
            : startUnitPosition.y + unitRange.height / 2
        var pixelPos = CGPoint(
            x: isVertical ? midPos : value,
            y: isVertical ? value : midPos
            ).applying(mat)
        
        // pixelInterval is the interval amount to traverse in pixel space for each iteration
        let pI = CGSize(
            width: isVertical ? 0.0 : interval,
            height: isVertical ? interval : 0.0
            ).applying(mat)
        let pixelInterval = CGSize(
            width: isVertical ? 0.0 : pI.width,
            height: isVertical ? pI.height : 0.0
        )
        
        // iterate along meter from start to end bounds
        let end = isVertical ? unitRect.maxY : unitRect.maxX
        while value < end {
            drawValueText(value: value, position: pixelPos)
            value += interval
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
