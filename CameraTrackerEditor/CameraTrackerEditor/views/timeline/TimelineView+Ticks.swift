//
//  TimelineView+Ticks.swift
//  CameraTrackerEditor
//
//  Created by Michael Levesque on 9/3/19.
//  Copyright © 2019 Michael Levesque. All rights reserved.
//

import Cocoa

extension TimelineView {
    /**
     Returns the interval width and height for major ticks.
     - Returns: Size of interval for major ticks in x and y direction.
    */
    internal func calculateMajorInterval() -> CGSize {
        let s = scale
        return CGSize(
            width: calculateMajorInterval(scale: s.width),
            height: calculateMajorInterval(scale: s.height)
        )
    }
    
    /**
     Returns the interval width and height for minor ticks.
     - Returns: Size of interval for minor ticks in x and y direction.
    */
    internal func calculateMinorInterval() -> CGSize {
        let s = scale
        return CGSize(
            width: calculateMinorInterval(scale: s.width),
            height: calculateMinorInterval(scale: s.height)
        )
    }
    
    /**
     Returns where the starting position should be for the given interval so
     so that the intevals will be aligned to zero in both x and y directions.
     - Parameter withInterval: The interval distance along x and y directions.
     - Parameter withStartPosition: The starting position of the graph along x
     and y directions.
     - Returns: The adjusted starting position so that some multiple of the
     given interval will align to zero.
     */
    internal func calculateStartIntervalPos( interval: CGSize,
                                             start: CGPoint) -> CGPoint {
        return CGPoint(
            x: calculateStartIntervalPos(
                withInterval: interval.width,
                withStartPosition: start.x
            ),
            y: calculateStartIntervalPos(
                withInterval: interval.height,
                withStartPosition: start.y
            )
        )
    }
    
    /**
     Adjusts the given rect in unit space so that it starts in an x and y
     position so that the given interval will be properly aligned to zero.
     - Parameter fromUnitRect: The rect in unit space to adjust.
     - Parameter withInterval: The interval in the x and y direction in unit
        space to use for adjusting the returned rect.
     - Returns: The adjusted rect in unit space that will be expanded to the
        left and down directions so that a multiple of the given interval will
        be aligned to zero.
    */
    internal func buildIntervalAdjustedUnitRect( fromUnitRect unitRect: CGRect,
                                                 withInterval interval: CGSize
                                                ) -> CGRect {
        // calculate the new origin
        let origin = calculateStartIntervalPos(
            interval: interval,
            start: unitRect.origin
        )
        return CGRect(
            origin: origin,
            // size needs to be readjusted by the newly offsetted origin
            // so that the rect ends in the space place
            size: CGSize(
                width: unitRect.width + unitRect.minX - origin.x,
                height: unitRect.height + unitRect.minY - origin.y
            )
        )
    }
    
    /**
     Draws tick lines to the given graphics context within the given rect in
     unit space in the given direction with the given properties.
     - Parameter toContext: The graphics context to draw to.
     - Parameter inUnitRect: The area in unit space that we should draw the
        ticks.
     - Parameter withTransform: Transformation matrix for transforming from unit
        to pixel space.
     - Parameter withInterval: The space between each tick. This should be
        non-zero in the direction of the spaces between each tick and should be
        zero in the other direction.
     - Parameter useVerticalTicks: If true, then ticks will be prepared to be
        drawn vertically. This determines which component (x or y) to check
        against when iterating through tick draws.
     - Parameter withTickWidth: The width in pixels for each tick line.
     - Parameter withTickColor: The color for each tick line.
    */
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
        // pos1 is the start of the tick line
        // pos2 is the end of the tick line
        var pos1 = calculateStartIntervalPos(
            interval: interval,
            start: unitRect.origin
        )
        var pos2 = useVerticalTicks
            ? CGPoint(x: pos1.x, y: unitRect.maxY)
            : CGPoint(x: unitRect.maxX, y: pos1.y)
        
        // endPos is the location of where the last tick will be
        let endPos = unitRect.origin + unitRect.size
        
        // condition is our check at every loop to determine if we have reached
        // the end in whichever direction we are drawing
        let condition = useVerticalTicks
            ? {pos1.x < endPos.x}
            : {pos1.y < endPos.y}
        
        // plot ticks
        while condition() {
            // draw tick line
            context.move(to: pos1)
            context.addLine(to: pos2)
            
            // move to next position
            pos1 += interval
            pos2 += interval
        }
        
        // restore state of context to remove transforms before applying
        // line width so that the line width isn't scaled incorrectly
        context.restoreGState()
        context.setLineWidth(tickWidth)
        context.setStrokeColor(tickColor)
        
        // present
        context.drawPath(using: .stroke)
    }
    
    /**
     Draws the horizontal and vertical zero ticks if they are within the
     given rect in unit space to the given context.
     - Parameter toContext: The graphics context to draw to.
     - Parameter inUnitRect: The rect are to draw in unit space.
     - Parameter withTransform: Transform matrix from unit to pixel space.
     - Parameter showHorizontal: If true, will draw the horizontal zero tick.
     - Parameter showVertical: If true, will draw the vertical zero tick.
     - Parameter withTickWidth: The width of the tick lines in pixels.
     - Parameter withTickColor: The color of the tick lines.
    */
    internal func drawZeroTicks( toContext context: CGContext,
                                 inUnitRect unitRect: CGRect,
                                 withTransform transform: CGAffineTransform,
                                 showHorizontal: Bool,
                                 showVertical: Bool,
                                 withTickWidth tickWidth: CGFloat,
                                 withTickColor tickColor: CGColor) {
        context.saveGState()
        context.concatenate(transform)
        
        // vertical line
        let isVerticalInArea = unitRect.minX < 0 && unitRect.maxX > 0
        if showVertical && isVerticalInArea {
            context.move(to: CGPoint(x: 0.0, y: unitRect.minY))
            context.addLine(to: CGPoint(x: 0.0, y: unitRect.maxY))
        }
        
        // horizontal line
        let isHorizontalInArea = unitRect.minY < 0 && unitRect.maxY > 0
        if showHorizontal && isHorizontalInArea {
            context.move(to: CGPoint(x: unitRect.minX, y: 0.0))
            context.addLine(to: CGPoint(x: unitRect.maxX, y: 0.0))
        }
        
        context.restoreGState()
        context.setLineWidth(tickWidth)
        context.setStrokeColor(tickColor)
        context.drawPath(using: .stroke)
    }
    
    
    /**
     Returns where the starting position should be for the given interval so
     so that the intevals will be aligned to zero.
     - Parameter withInterval: The interval distance along an axis for ticks.
     - Parameter withStartPosition: The starting position of the graph along an
        axis.
     - Returns: The adjusted starting position so that some multiple of the
        given interval will align to zero.
    */
    private func calculateStartIntervalPos( withInterval interval: CGFloat,
                                            withStartPosition start: CGFloat
                                            ) -> CGFloat {
        if interval == 0.0 {
            return start
        }
        let multiplier = ceil(start / interval)
        return interval * multiplier
    }
    
    /**
     Returns the interval in some direction for major ticks.
     - Returns: Size of interval for major ticks in some direction.
    */
    private func calculateMajorInterval(scale: CGFloat) -> CGFloat {
        let pixelDistancePerHalfUnit: CGFloat = 1.0 * scale
        return ceil(tickInterval / pixelDistancePerHalfUnit)
    }
    
    /**
     Returns the interval in some direction for minor ticks.
     - Returns: Size of interval for minor ticks in some direction.
    */
    private func calculateMinorInterval(scale: CGFloat) -> CGFloat {
        let pixelDistancePerHalfUnit: CGFloat = 0.5 * scale
        let multiplier = floor(pixelDistancePerHalfUnit / tickInterval)
        return multiplier == 0.0 ? 0.0 : 0.5 / multiplier
    }
}
