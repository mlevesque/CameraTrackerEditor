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
    
    // color for the background
    @IBInspectable var backgroundColor: NSColor = NSColor.darkGray
    @IBInspectable var borderColor: NSColor = NSColor.lightGray
    
    
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
        
        // draw zero tick
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
    }
    
    private func drawBackground(context: CGContext) {
        let rect = CGRect(x: 0.0, y: 0.0, width: frame.width, height: frame.height)
        context.setLineWidth(1.0)
        context.setFillColor(backgroundColor.cgColor)
        context.setStrokeColor(borderColor.cgColor)
        context.addRect(rect)
        context.drawPath(using: .fillStroke)
    }
}
