//
//  TimelineView+Graph.swift
//  CameraTrackerEditor
//
//  Created by Michael Levesque on 9/3/19.
//  Copyright © 2019 Michael Levesque. All rights reserved.
//

import Cocoa

extension TimelineView {
    /**
     Performs all drawing for the graph to the given context within the given
     draw area.
     - Parameter inContext: The graphics context to draw to.
     - Parameter inPixelRect: The draw area in pixel space.
     - Parameter withMinorInterval: Interval for minor ticks in unit space.
     - Parameter withMajorInterval: Interval for major ticks in unit space.
    */
    internal func drawGraph( inContext context: CGContext,
                             inPixelRect dirtyRect: NSRect,
                             withMinorInterval minorInterval: CGSize,
                             withMajorInterval majorInterval: CGSize) {
        // update the thresholds. These are used for level of detail rendering
        // for the data points
        updateThresholds()
        
        // set up clip
        context.clip(to: dirtyRect)
        
        // transform draw area to unit space
        let unitRect = buildUnitRect(
            fromPixelRect: dirtyRect,
            withTransform: pixelToUnitTransform
        )
        
        // minor vertical ticks
        if minorInterval.width > 0.0 {
            drawTicks(
                toContext: context,
                inUnitRect: unitRect,
                withTransform: unitToPixelTransform,
                withInterval: CGSize(
                    width: minorInterval.width,
                    height: 0.0
                ),
                useVerticalTicks: true,
                withTickWidth: tMinorWidth,
                withTickColor: tMinorColor.cgColor
            )
        }
        // minor horizontal ticks
        if minorInterval.height > 0.0 {
            drawTicks(
                toContext: context,
                inUnitRect: unitRect,
                withTransform: unitToPixelTransform,
                withInterval: CGSize(width: 0.0, height: minorInterval.height),
                useVerticalTicks: false,
                withTickWidth: tMinorWidth,
                withTickColor: tMinorColor.cgColor
            )
        }
        
        // major vertical ticks
        drawTicks(
            toContext: context,
            inUnitRect: unitRect,
            withTransform: unitToPixelTransform,
            withInterval: CGSize(width: majorInterval.width, height: 0.0),
            useVerticalTicks: true,
            withTickWidth: tMajorWidth,
            withTickColor: tMajorColor.cgColor
        )
        drawTicks(
            toContext: context,
            inUnitRect: unitRect,
            withTransform: unitToPixelTransform,
            withInterval: CGSize(width: 0.0, height: majorInterval.height),
            useVerticalTicks: false,
            withTickWidth: tMajorWidth,
            withTickColor: tMajorColor.cgColor
        )
        
        // draw zero tick
        drawZeroTicks(
            toContext: context,
            inUnitRect: unitRect,
            withTransform: unitToPixelTransform,
            showHorizontal: true,
            showVertical: true,
            withTickWidth: tZeroWidth,
            withTickColor: tZeroColor.cgColor
        )
        
        drawData(inContext: context, withTransform: unitToPixelTransform)
        
        context.resetClip()
    }
    
    
    /**
     Transforms the given threshold value in pixel space and returns the
     threshold value in unit space.
     - Parameter fromPixelThreshold: The threshold value in pixel space to
        transform.
     - Parameter withTransform: Transform matrix from pixel to unit space.
     - Returns: The transformed threshold value in unit space.
    */
    private func calculateUnitThreshold(
                        fromPixelThreshold threshold: CGFloat,
                        withTransform transform: CGAffineTransform) -> CGFloat {
        let result = CGSize(
            width: threshold,
            height: threshold
        ).applying(transform)
        return min(result.width, result.height)
    }
    
    /**
     Updates the calculations for all thresholds for level of detail rendering
     for the tracking data.
    */
    private func updateThresholds() {
        _dataLinearThresholdInUnits = calculateUnitThreshold(
            fromPixelThreshold: dataLinearThreshold,
            withTransform: pixelToUnitTransform
        )
        _dataCubicThresholdInUnits = calculateUnitThreshold(
            fromPixelThreshold: dataCubicThreshold,
            withTransform: pixelToUnitTransform
        )
        _subdivisionIntervalInUnits = calculateUnitThreshold(
            fromPixelThreshold: subdivisionInterval,
            withTransform: pixelToUnitTransform
        )
    }
    
    /**
     Draws all tracking data to the given context.
     - Parameter inContext: The graphics context to draw to.
     - Parameter withTransform: The transform matrix for transforming from
        unit to pixel space.
    */
    private func drawData( inContext context: CGContext,
                           withTransform transform: CGAffineTransform) {
        // don't draw if we can't get the index bounds from the data
        guard let startIndex = trackingData?.getEntryIndex(
                fromTime: Double(startUnitPosition.x)
            ),
            let endIndex = trackingData?.getEntryIndex(
                fromTime: Double(endUnitPosition.x)
            ) else {
                return
        }
        
        if showPositionX {
            drawDataComponent(
                inContext: context, withComponent: .PositionX,
                withColor: xPosColor.cgColor, fromIndex: startIndex,
                toIndex: endIndex, withTransform: transform
            )
        }
        if showPositionY {
            drawDataComponent(
                inContext: context, withComponent: .PositionY,
                withColor: yPosColor.cgColor, fromIndex: startIndex,
                toIndex: endIndex, withTransform: transform
            )
        }
        if showPositionZ {
            drawDataComponent(
                inContext: context, withComponent: .PositionZ,
                withColor: zPosColor.cgColor, fromIndex: startIndex,
                toIndex: endIndex, withTransform: transform
            )
        }
        if showRotationX {
            drawDataComponent(
                inContext: context, withComponent: .RotationX,
                withColor: xRotColor.cgColor, fromIndex: startIndex,
                toIndex: endIndex, withTransform: transform
            )
        }
        if showRotationY {
            drawDataComponent(
                inContext: context, withComponent: .RotationY,
                withColor: yRotColor.cgColor, fromIndex: startIndex,
                toIndex: endIndex, withTransform: transform
            )
        }
        if showRotationZ {
            drawDataComponent(
                inContext: context, withComponent: .RotationZ,
                withColor: zRotColor.cgColor, fromIndex: startIndex,
                toIndex: endIndex, withTransform: transform
            )
        }
    }
    
    /**
     Draws a graph of tracking data for the given component to the given
     graphics context from one data entry index to the other. Before drawing
     between a pair of data points, this will perform level of detail checking
     to determine how detailed to draw a line or curve between the points.
     - Parameter inContext: The graphics context to draw to.
     - Parameter withComponent: The data component to draw the graph for, e.g.
        a position of rotation component from the tracking data.
     - Parameter withColor: The color of the graph that will be drawn.
     - Parameter fromIndex: The index of the starting data entry from the
        tracking data to start drawing from.
     - Parameter toIndex: The index of the last data entry from the tracking
        data to end drawing at.
     - Parameter withTransform: The transform matrix from unit to pixel space.
    */
    private func drawDataComponent( inContext context: CGContext,
                                    withComponent component: TrackingComponent,
                                    withColor color: CGColor,
                                    fromIndex startIndex: Int,
                                    toIndex endIndex: Int,
                                    withTransform transform: CGAffineTransform){
        // move to starting position
        guard var entry1 = trackingData!.getData(
                    atIndex: startIndex,
                    forComponent: component) else {
            return
        }
        context.saveGState()
        context.concatenate(transform)
        context.move(to: CGPoint(x: entry1.time, y: Double(entry1.value)))
        
        // draw lines
        for index in startIndex..<endIndex {
            // get data entry pairs
            guard let entry2 = trackingData?.getData(
                    atIndex: index + 1,
                    forComponent: component) else {
                continue
            }
            
            // get x and y differences to determine level of detail
            let diff = CGFloat(
                abs(
                    min(
                        entry2.time - entry1.time,
                        Double(entry2.value - entry1.value)
                    )
                )
            )
            
            // if less than linear threshold, then don't bother drawing
            if diff < _dataLinearThresholdInUnits && index < endIndex - 1 {
                // note that in this situation, entry1 will stay where it is so
                // that each successive iteration will accumulate x and y
                // difference until it passes the threshold.
                // this fixes some visual LOD issues in the graphs
                continue
            }
                
                // else, if less than cubic threshold, then just draw a line
            else if diff < _dataCubicThresholdInUnits {
                context.addLine(
                    to: CGPoint(
                        x: CGFloat(entry2.time),
                        y: CGFloat(entry2.value)
                    )
                )
                entry1 = entry2
            }
                
                // else, draw it with cubic interpolation
            else {
                // subdivisions is determined by how big the difference is
                // the bigger teh difference, the more subdivisions
                let subdivisions = Int(
                    floor(diff / _subdivisionIntervalInUnits)
                )
                if let dataValues = trackingData?.getData(
                    fromIndex: index,
                    toIndex: index + 1,
                    forComponent: component,
                    withSubdivisions: subdivisions,
                    withInterpolation: .Cubic) {
                    for data in dataValues {
                        context.addLine(
                            to: CGPoint(x: data.time, y: Double(data.value))
                        )
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
