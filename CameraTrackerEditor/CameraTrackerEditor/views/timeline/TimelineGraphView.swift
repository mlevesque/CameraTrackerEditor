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
    var dataPointLinearThreshold: Double = 1.0
    var dataPointCubicThreshold: Double = 60.0
    var interpolationSubdivisionThreshold: Double = 20.0
    
    
    private var m_trackingData: TrackingData?
    
    
    var showPositionX: Bool = true
    var showPositionY: Bool = true
    var showPositionZ: Bool = true
    var showRotationX: Bool = true
    var showRotationY: Bool = true
    var showRotationZ: Bool = true
    
    
    var m_linearPixelThreshold: CGFloat
    var m_cubicPixelThreshold: CGFloat
    var m_subdivisionPixelThreshold: CGFloat
    
    
    required init?(coder decoder: NSCoder) {
        m_linearPixelThreshold = 1.0
        m_cubicPixelThreshold = 1.0
        m_subdivisionPixelThreshold = 1.0
        super.init(coder: decoder)
    }
    
    
    func setTrackingData(data: TrackingData?) {
        m_trackingData = data
    }
    
    
    private func calculateUnitThreshold( fromPixelThreshold threshold: Double,
                                         withTransform transform: CGAffineTransform) -> CGFloat {
        let result = CGSize(width: threshold, height: threshold).applying(transform)
        return min(result.width, result.height)
    }
    
    override func draw(_ dirtyRect: NSRect) {
        // get the context
        guard let context = NSGraphicsContext.current?.cgContext else {
            return
        }
        
        // build transform
        updateTransform()
        let invertedTransform = m_currentTransform.inverted()
        m_linearPixelThreshold = calculateUnitThreshold(
            fromPixelThreshold: dataPointLinearThreshold,
            withTransform: invertedTransform
        )
        m_cubicPixelThreshold = calculateUnitThreshold(
            fromPixelThreshold: dataPointCubicThreshold,
            withTransform: invertedTransform
        )
        m_subdivisionPixelThreshold = calculateUnitThreshold(
            fromPixelThreshold: interpolationSubdivisionThreshold,
            withTransform: invertedTransform
        )
        let unitRect = buildUnitRect(fromPixelRect: dirtyRect, withTransform: invertedTransform)

        // minor Vertical Ticks
        let minorInterval = calculateMinorInterval()
        if minorInterval.width > 0.0 {
            let minorIntervalVertical = CGSize(width: minorInterval.width, height: 0.0)
            let minorUnitRectVertical = buildIntervalAdjustedUnitRect(
                fromUnitRect: unitRect,
                withInterval: minorIntervalVertical
            )
            drawTicks(
                toContext: context,
                inUnitRect: minorUnitRectVertical,
                withTransform: m_currentTransform,
                withInterval: CGSize(width: minorInterval.width, height: 0.0),
                useVerticalTicks: true,
                withTickWidth: tickMinorWidth,
                withTickColor: tickMinorColor.cgColor
            )
        }
        // minor horizontal ticks
        if minorInterval.height > 0.0 {
            let minorIntervalHorizontal = CGSize(width: 0.0, height: minorInterval.height)
            let minorUnitRectHorizontal = buildIntervalAdjustedUnitRect(
                fromUnitRect: unitRect,
                withInterval: minorIntervalHorizontal
            )
            drawTicks(
                toContext: context,
                inUnitRect: minorUnitRectHorizontal,
                withTransform: m_currentTransform,
                withInterval: CGSize(width: 0.0, height: minorInterval.height),
                useVerticalTicks: false,
                withTickWidth: tickMinorWidth,
                withTickColor: tickMinorColor.cgColor
            )
        }

        // major vertical ticks
        let majorInterval = calculateMajorInterval()
        let majorIntervalVertical = CGSize(width: majorInterval.width, height: 0.0)
        let majorUnitRectVertical = buildIntervalAdjustedUnitRect(
            fromUnitRect: unitRect,
            withInterval: majorIntervalVertical
        )
        drawTicks(
            toContext: context,
            inUnitRect: majorUnitRectVertical,
            withTransform: m_currentTransform,
            withInterval: majorIntervalVertical,
            useVerticalTicks: true,
            withTickWidth: tickMajorWidth,
            withTickColor: tickMajorColor.cgColor
        )
        let majorIntervalHorizontal = CGSize(width: 0.0, height: majorInterval.height)
        let majorUnitRectHorizontal = buildIntervalAdjustedUnitRect(
            fromUnitRect: unitRect,
            withInterval: majorIntervalHorizontal
        )
        drawTicks(
            toContext: context,
            inUnitRect: majorUnitRectHorizontal,
            withTransform: m_currentTransform,
            withInterval: majorIntervalHorizontal,
            useVerticalTicks: false,
            withTickWidth: tickMajorWidth,
            withTickColor: tickMajorColor.cgColor
        )

        // draw zero tick
        drawZeroTick(
            toContext: context,
            inUnitRect: unitRect,
            withTransform: m_currentTransform,
            showHorizontal: true,
            showVertical: true,
            withTickWidth: tickZeroWidth,
            withTickColor: tickZeroColor.cgColor
        )

        drawData(inContext: context, withTransform: m_currentTransform)
    }

    private func drawData(inContext context: CGContext, withTransform transform: CGAffineTransform) {
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
                withTransform: transform
            )
        }
        if showPositionY {
            drawDataComponent(
                inContext: context,
                withComponent: .PositionY,
                color: yPosColor.cgColor,
                startIndex: startIndex,
                endIndex: endIndex,
                withTransform: transform
            )
        }
        if showPositionZ {
            drawDataComponent(
                inContext: context,
                withComponent: .PositionZ,
                color: zPosColor.cgColor,
                startIndex: startIndex,
                endIndex: endIndex,
                withTransform: transform
            )
        }
        if showRotationX {
            drawDataComponent(
                inContext: context,
                withComponent: .RotationX,
                color: xRotColor.cgColor,
                startIndex: startIndex,
                endIndex: endIndex,
                withTransform: transform
            )
        }
        if showRotationY {
            drawDataComponent(
                inContext: context,
                withComponent: .RotationY,
                color: yRotColor.cgColor,
                startIndex: startIndex,
                endIndex: endIndex,
                withTransform: transform
            )
        }
        if showRotationZ {
            drawDataComponent(
                inContext: context,
                withComponent: .RotationZ,
                color: zRotColor.cgColor,
                startIndex: startIndex,
                endIndex: endIndex,
                withTransform: transform
            )
        }
    }

    private func drawDataComponent( inContext context: CGContext,
                                    withComponent component: TrackingComponent,
                                    color: CGColor,
                                    startIndex: Int,
                                    endIndex: Int,
                                    withTransform transform: CGAffineTransform) {
        // move to starting position
        guard var entry1 = m_trackingData!.getData(atIndex: startIndex, forComponent: component) else {
            return
        }
        context.saveGState()
        context.concatenate(transform)
        context.move(to: CGPoint(x: entry1.time, y: Double(entry1.value)))

        // draw lines
        for index in startIndex..<endIndex {
            // get data entry pairs
            guard let entry2 = m_trackingData?.getData(atIndex: index + 1, forComponent: component) else {
                continue
            }
            
            // get x and y differences to determine level of detail
            let diff = CGFloat(abs(min(entry2.time - entry1.time, Double(entry2.value - entry1.value))))
            
            // if less than linear threshold, then don't bother drawing
            if diff < m_linearPixelThreshold && index < endIndex - 1 {
                // note that in this situation, entry1 will stay where it is so that each successive
                // iteration will accumulate x and y difference until it passes the threshold.
                // this fixes some visual LOD issues in the graphs
                continue
            }
                
            // else, if less than cubic threshold, then just draw a line
            else if diff < m_cubicPixelThreshold {
                context.addLine(to: CGPoint(x: CGFloat(entry2.time), y: CGFloat(entry2.value)))
                entry1 = entry2
            }
                
            // else, draw it with cubic interpolation
            else {
                // subdivisions is determined by how big the difference is
                // the bigger teh difference, the more subdivisions
                let subdivisions = Int(floor(diff / m_subdivisionPixelThreshold))
                if let dataValues = m_trackingData?.getData(
                                                            fromIndex: index,
                                                            toIndex: index + 1,
                                                            forComponent: component,
                                                            withSubdivisions: subdivisions,
                                                            withInterpolation: .Cubic) {
                    for data in dataValues {
                        context.addLine(to: CGPoint(x: data.time, y: Double(data.value)))
                    }
                }
                entry1 = entry2
            }
        }
        context.restoreGState()
        context.setLineWidth(lineWidth)
        context.setStrokeColor(color)
        context.drawPath(using: .stroke)
    }
}
