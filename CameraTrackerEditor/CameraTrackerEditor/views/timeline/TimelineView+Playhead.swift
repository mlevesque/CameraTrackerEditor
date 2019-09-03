//
//  TimelineView+Playhead.swift
//  CameraTrackerEditor
//
//  Created by Michael Levesque on 9/3/19.
//  Copyright © 2019 Michael Levesque. All rights reserved.
//

import Cocoa

extension TimelineView {
    /**
     Draws the playhead to the given context and using the given rect to
     determine its length and width.
     - Parameter inContext: The graphics context to draw to.
     - Parameter inPixelRect: The draw area for the playhead.
    */
    internal func drawPlayhead( inContext context: CGContext,
                                inPixelRect pixelRect: NSRect) {
        // draw head
        context.move(to: CGPoint(       // top left
            x: pixelRect.minX + 1,
            y: pixelRect.maxY - 5)
        )
        context.addLine(to: CGPoint(    // top right
            x: pixelRect.maxX - 1,
            y: pixelRect.maxY - 5)
        )
        context.addLine(to: CGPoint(    // bottom right
            x: pixelRect.maxX - 1,
            y: pixelRect.maxY - 12)
        )
        context.addLine(to: CGPoint(    // bottom point
            x: pixelRect.minX + pixelRect.width / 2,
            y: pixelRect.maxY - 20)
        )
        context.addLine(to: CGPoint(    // bottom left
            x: pixelRect.minX + 1,
            y: pixelRect.maxY - 12)
        )
        context.addLine(to: CGPoint(    // top left
            x: pixelRect.minX + 1,
            y: pixelRect.maxY - 5)
        )
        context.setFillColor(
            CGColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 0.5)
        )
        context.setStrokeColor(
            CGColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0)
        )
        context.drawPath(using: .fillStroke)
        
        // draw line
        context.move(to: CGPoint(
            x: pixelRect.minX + pixelRect.width / 2, y: pixelRect.maxY - 20)
        )
        context.addLine(to: CGPoint(
            x: pixelRect.minX + pixelRect.width / 2, y: 0)
        )
        context.setStrokeColor(
            CGColor.init(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0)
        )
        context.drawPath(using: .stroke)
    }
}
