//
//  TimelineGraphView.swift
//  CameraTrackerEditor
//
//  Created by Michael Levesque on 8/28/19.
//  Copyright © 2019 Michael Levesque. All rights reserved.
//

import Cocoa

class TimelineGraphView : TimelineViewBase {
    var xPosColor: NSColor = NSColor.red
    var yPosColor: NSColor = NSColor.green
    var zPosColor: NSColor = NSColor.blue
    var xRotColor: NSColor = NSColor.systemPink
    var yRotColor: NSColor = NSColor.yellow
    var zRotColor: NSColor = NSColor.purple
    var lineWidth: CGFloat = 2.0
    
    
    private var m_trackingData: TrackingData?
    
    var showPositionX: Bool = true
    var showPositionY: Bool = true
    var showPositionZ: Bool = true
    var showRotationX: Bool = true
    var showRotationY: Bool = true
    var showRotationZ: Bool = true
    
    
    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
    }
    
    
    func setTrackingData(data: TrackingData?) {
        m_trackingData = data
    }
    
    
    override func draw(_ dirtyRect: NSRect) {
        // get the context
        guard let context = NSGraphicsContext.current?.cgContext else {
            return
        }

        // minor Vertical Ticks
        let s = scale
        let minorInterval = calculateMinorInterval()
        if minorInterval.width > 0.0 {
            drawTicks(
                toContext: context,
                inPixelRect: dirtyRect,
                atUnitStartPos: startUnitPosition,
                atScale: s,
                withInterval: minorInterval.width,
                usingPlottingClosure: plotVerticalLines(inContext:fromStartPos:toEndPos:withInterval:),
                withTickWidth: tickMinorWidth,
                withTickColor: tickMinorColor.cgColor
            )
        }
        // minor horizontal ticks
        if minorInterval.height > 0.0 {
            drawTicks(
                toContext: context,
                inPixelRect: dirtyRect,
                atUnitStartPos: startUnitPosition,
                atScale: s,
                withInterval: minorInterval.height,
                usingPlottingClosure: plotHorizontalLines(inContext:fromStartPos:toEndPos:withInterval:),
                withTickWidth: tickMinorWidth,
                withTickColor: tickMinorColor.cgColor
            )
        }

        // major vertical ticks
        let majorInterval = calculateMajorInterval()
        drawTicks(
            toContext: context,
            inPixelRect: dirtyRect,
            atUnitStartPos: startUnitPosition,
            atScale: s,
            withInterval: majorInterval.width,
            usingPlottingClosure: plotVerticalLines(inContext:fromStartPos:toEndPos:withInterval:),
            withTickWidth: tickMajorWidth,
            withTickColor: tickMajorColor.cgColor
        )
        drawTicks(
            toContext: context,
            inPixelRect: dirtyRect,
            atUnitStartPos: startUnitPosition,
            atScale: s,
            withInterval: majorInterval.height,
            usingPlottingClosure: plotHorizontalLines(inContext:fromStartPos:toEndPos:withInterval:),
            withTickWidth: tickMajorWidth,
            withTickColor: tickMajorColor.cgColor
        )

        // draw zero tick
        let zeroEndPos = endUnitPosition
        drawZeroTick(
            toContext: context,
            fromStartPos: startUnitPosition,
            toEndPos: CGPoint(
                x: zeroEndPos.x,
                y: zeroEndPos.y
            ),
            atScale: s,
            showHorizontal: true,
            showVertical: true,
            withTickWidth: tickZeroWidth,
            withTickColor: tickZeroColor.cgColor
        )

        drawData(inContext: context)
    }

    private func drawData(inContext context: CGContext) {
        guard let startIndex = m_trackingData?.getEntryIndex(fromTime: Double(startUnitPosition.x)),
            let endIndex = m_trackingData?.getEntryIndex(fromTime: Double(startUnitPosition.x + unitRange.width)) else {
                return
        }

        if showPositionX {
            drawDataComponent(
                inContext: context,
                withComponent: .PositionX,
                color: xPosColor.cgColor,
                startIndex: startIndex,
                endIndex: endIndex,
                subdivisions: 1,
                interpolation: .Linear
            )
        }
        if showPositionY {
            drawDataComponent(
                inContext: context,
                withComponent: .PositionY,
                color: yPosColor.cgColor,
                startIndex: startIndex,
                endIndex: endIndex,
                subdivisions: 1,
                interpolation: .Linear
            )
        }
        if showPositionZ {
            drawDataComponent(
                inContext: context,
                withComponent: .PositionZ,
                color: zPosColor.cgColor,
                startIndex: startIndex,
                endIndex: endIndex,
                subdivisions: 1,
                interpolation: .Linear
            )
        }
        if showRotationX {
            drawDataComponent(
                inContext: context,
                withComponent: .RotationX,
                color: xRotColor.cgColor,
                startIndex: startIndex,
                endIndex: endIndex,
                subdivisions: 1,
                interpolation: .Linear
            )
        }
        if showRotationY {
            drawDataComponent(
                inContext: context,
                withComponent: .RotationY,
                color: yRotColor.cgColor,
                startIndex: startIndex,
                endIndex: endIndex,
                subdivisions: 1,
                interpolation: .Linear
            )
        }
        if showRotationZ {
            drawDataComponent(
                inContext: context,
                withComponent: .RotationZ,
                color: zRotColor.cgColor,
                startIndex: startIndex,
                endIndex: endIndex,
                subdivisions: 1,
                interpolation: .Linear
            )
        }
    }

    private func drawDataComponent( inContext context: CGContext,
                                    withComponent component: TrackingComponent,
                                    color: CGColor,
                                    startIndex: Int,
                                    endIndex: Int,
                                    subdivisions: Int,
                                    interpolation: InterpolationMethod ) {
        // move to starting position
        guard let data = m_trackingData!.getData(atIndex: startIndex, forComponent: component) else {
            return
        }
        context.saveGState()
        applyTransforms(toContext: context, atStartPos: startUnitPosition, atScale: scale)
        context.move(to: CGPoint(x: data.time, y: Double(data.value)))

        // draw lines
        for index in startIndex..<endIndex {
            if let dataValues = m_trackingData?.getData(
                            fromIndex: index,
                            toIndex: index + 1,
                            forComponent: component,
                            withSubdivisions: subdivisions,
                            withInterpolation: interpolation) {
                for data in dataValues {
                    context.addLine(to: CGPoint(x: data.time, y: Double(data.value)))
                }
            }
        }
        context.restoreGState()
        context.setLineWidth(lineWidth)
        context.setStrokeColor(color)
        context.drawPath(using: .stroke)
    }
}
