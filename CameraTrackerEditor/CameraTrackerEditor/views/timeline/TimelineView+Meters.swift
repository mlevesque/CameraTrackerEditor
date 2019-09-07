//
//  TimelineView+Meters.swift
//  CameraTrackerEditor
//
//  Created by Michael Levesque on 9/3/19.
//  Copyright © 2019 Michael Levesque. All rights reserved.
//

import Cocoa

extension TimelineView {
    /**
     Draws a timeline meter with the given graphics context in the given pixel
     location.
     - Parameter inContext: The graphics context to draw to.
     - Parameter inPixelRect: The draw area for the meter.
     - Parameter isVertical: If true, this will draw the meter as a vertical
        one.
     - Parameter withMinorInterval: Interval distance for minor ticks. If
        isVertical is true, then the x component must be 0. If isVertical is
        false, then the y component must be 0.
     - Parameter withMajorInterval: Interval distance for major ticks. If
         isVertical is true, then the x component must be 0. If isVertical is
         false, then the y component must be 0.
    */
    internal func drawMeter( inContext context: CGContext,
                             inPixelRect dirtyRect: NSRect,
                             isVertical: Bool,
                             withMinorInterval minorInterval: CGSize,
                             withMajorInterval majorInterval: CGSize) {
        // setup clip
        context.clip(to: dirtyRect)
        
        // draw background
        let meterRect = isVertical
            ? _verticalMeterRect
            : _horizontalMeterRect
        drawBackground(
            inContext: context,
            withMeterRect: meterRect
        )
        
        // setup unit rect
        let unitRect = buildUnitRect(
            fromPixelRect: dirtyRect,
            withTransform: pixelToUnitTransform
        )
        
        // draw minor ticks
        let minorIntervalValue = isVertical
            ? minorInterval.height
            : minorInterval.width
        let adjustedMinorInterval = CGSize(
            width: isVertical ? 0 : minorIntervalValue,
            height: isVertical ? minorIntervalValue : 0
        )
        if minorIntervalValue > 0.0 {
            drawTicks(
                toContext: context,
                inUnitRect: unitRect,
                withTransform: unitToPixelTransform,
                withInterval: adjustedMinorInterval,
                useVerticalTicks: !isVertical,
                withTickWidth: tMinorWidth,
                withTickColor: tMMinorColor.cgColor
            )
        }
        
        // draw major ticks
        let adjustedMajorInterval = CGSize(
            width: isVertical ? 0 : majorInterval.width,
            height: isVertical ? majorInterval.height : 0
        )
        drawTicks(
            toContext: context,
            inUnitRect: unitRect,
            withTransform: unitToPixelTransform,
            withInterval: adjustedMajorInterval,
            useVerticalTicks: !isVertical,
            withTickWidth: tMajorWidth,
            withTickColor: tMMajorColor.cgColor
        )
        
        // draw special tick at zero
        drawZeroTicks(
            toContext: context,
            inUnitRect: unitRect,
            withTransform: unitToPixelTransform,
            showHorizontal: isVertical,
            showVertical: !isVertical,
            withTickWidth: tZeroWidth,
            withTickColor: tMZeroColor.cgColor
        )
        
        // draw divider
        drawDivider(
            inContext: context,
            inPixelRect: meterRect,
            isVertical: isVertical
        )
        
        // draw number values
        let textInterval = calculateTextInterval(
            isVertical: isVertical,
            minorInterval: minorInterval,
            majorInterval: majorInterval
        )
        drawText(
            inContext: context,
            inUnitRect: unitRect,
            inPixelRect: meterRect,
            withTransform: unitToPixelTransform,
            withInterval: textInterval,
            isVertical: isVertical
        )
        
        context.resetClip()
    }
    
    /**
     Returns a calculated interval size to use for interval space between
     text values.
     - Parameter isVertical: If true, then the interval will have a value
        for height and zero for width. If false, then the interval will have a
        value for width and zero for height.
     - Parameter minorInterval: The interval length for minor ticks. This is
        used if it is non-zero and will make the text interval be for every two
        minor interval lengths.
     - Parameter majorInterval: The interval length for major ticks. This is
        used if teh minor interval is zero.
     - Returns: The interval to use for spacing out text values.
    */
    private func calculateTextInterval( isVertical: Bool,
                                        minorInterval: CGSize,
                                        majorInterval: CGSize) -> CGSize {
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
    
    /**
     Draws the background rectangle for the meter at the given graphics context
     in the given rect.
     - Parameter inContext: The graphics context to draw to.
     - Parameter withMeterRect: The rect representing the full meter draw area.
    */
    private func drawBackground( inContext context: CGContext,
                                 withMeterRect rect: CGRect) {
        context.saveGState()
        context.setLineWidth(1.0)
        context.setFillColor(meterBackgroundColor.cgColor)
        context.setStrokeColor(meterBorderColor.cgColor)
        context.addRect(rect)
        context.drawPath(using: .fillStroke)
        context.restoreGState()
    }
    
    /**
     Draws a divider between a meter and the graph in the given graphics
     context in the given draw area.
     - Parameter inContext: The graphics context to draw to.
     - Parameter inPixelRect: The draw area.
     - Parameter isVertical: Determines where to draw the divider. If true, it
        is drawn on the right side. If false, it is drawn on the bottom.
    */
    private func drawDivider( inContext context: CGContext,
                              inPixelRect rect: CGRect,
                              isVertical: Bool) {
        // for vertical meter, draw divider on right size of meter
        if isVertical {
            context.move(to: CGPoint(x: rect.maxX, y: rect.minY))
            context.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        }
        // for horizontal meter, draw divider on bottom of meter
        else {
            context.move(to: CGPoint(x: rect.minX, y: rect.minY))
            context.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        }
        context.setStrokeColor(meterDividerColor.cgColor)
        context.setLineWidth(1.0)
        context.drawPath(using: .stroke)
    }
    
    /**
     Returns a new interval to only go one direction while zeroing out the other
     based on the given flag.
     - Parameter withInterval: The interval to adjust into one direction.
     - Parameter isVertical: If true, then the x component is zeroed out. If
        false, then the y component gets zeroed out.
    */
    private func adjustInterval( withInterval interval: CGSize,
                                 isVertical: Bool) -> CGSize {
        return CGSize(
            width: isVertical ? 0.0 : interval.width,
            height: isVertical ? interval.height : 0.0
        )
    }
    
    /**
     Draws all text values only the meter in the given context with the given
     properties.
     - Parameter inContext: The graphics context to draw to.
     - Parameter inUnitRect: The rect in unit space to draw in.
     - Parameter inPixelRect: The rect in pixel space to draw in.
     - Parameter withTransform: The transform matrix to used for positioning.
     - Parameter withInterval: The spacing between each text value. Use
        calculateTextInterval to calculate the interval.
     - Parameter isVertical: Determines the direction for drawing the text
        values.
    */
    private func drawText( inContext context: CGContext,
                           inUnitRect unitRect: CGRect,
                           inPixelRect pixelRect: CGRect,
                           withTransform transform: CGAffineTransform,
                           withInterval interval: CGSize,
                           isVertical: Bool) {
        // pixelPos represents the origin position for the text
        // midPos is a value that should be in the middle of the meter along its
        // short width
        let startUnitPos = calculateStartIntervalPos(
            interval: interval,
            start: CGPoint(
                x: isVertical ? 0 : unitRect.minX,
                y: isVertical ? unitRect.minY : 0
            )
        )
        var pixelPos = startUnitPos.applying(transform)
        pixelPos.x = isVertical
            ? pixelRect.width / 2
            : pixelPos.x
        pixelPos.y = isVertical
            ? pixelPos.y
            : pixelRect.minY + pixelRect.height / 2
        
        // pixelInterval is the interval amount to traverse in pixel space for
        // each iteration
        let pixelInterval = adjustInterval(
            withInterval: interval.applying(transform),
            isVertical: isVertical
        )
        
        // setup closures for iterations
        var pos = startUnitPos
        let condition = isVertical
            ? {pos.y < unitRect.maxY}
            : {pos.x < unitRect.maxX}
        let getValue = isVertical
            ? {pos.y}
            : {pos.x}
        
        // iterate along meter from start to end bounds
        while condition() {
            drawValueText(getValue(), atPosition: pixelPos)
            pos += interval
            pixelPos += pixelInterval
        }
    }
    
    /**
     Draws a single given text value at the given position.
     - Parameter value: The value to draw.
     - Parameter atPosition: The position to draw the text value. The text will
        be centered at this position.
    */
    private func drawValueText(_ value: CGFloat, atPosition position: CGPoint) {
        // set up formatting of the number
        guard let s = _numberFormatter.string(
                                    from: NSNumber(value: Float(value))) else {
            return
        }
        let text = NSString(string: s)
        
        // set up bounding area for drawing the text
        let minFrameSize = min(frame.width, frame.height)
        let size = CGSize(width: minFrameSize, height: minFrameSize)
        let boundingRect = text.boundingRect(
            with: size,
            options: [.usesLineFragmentOrigin],
            attributes: _textAttributes,
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
            attributes: _textAttributes,
            context: nil
        )
    }
}
