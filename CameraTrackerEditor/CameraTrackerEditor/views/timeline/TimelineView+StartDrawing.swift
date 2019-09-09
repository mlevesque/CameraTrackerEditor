//
//  TimelineView+StartDrawing.swift
//  CameraTrackerEditor
//
//  Created by Michael Levesque on 9/8/19.
//  Copyright © 2019 Michael Levesque. All rights reserved.
//

import Cocoa

extension TimelineView {
    
    /**
     Called when view is about be be drawn. Set up transforms and bounding
     rectangles for elements of the timeline.
     */
    override func viewWillDraw() {
        // update pixel rects for meters and graph
        _horizontalMeterRect = CGRect(
            x: verticalMeterThickness,
            y: frame.height - horizontalMeterThickness,
            width: frame.width - verticalMeterThickness,
            height: horizontalMeterThickness
        )
        _verticalMeterRect = CGRect(
            x: 0,
            y: 0,
            width: verticalMeterThickness,
            height: frame.height - horizontalMeterThickness
        )
        _graphRect = CGRect(
            x: _verticalMeterRect.maxX,
            y: 0,
            width: _horizontalMeterRect.width,
            height: _verticalMeterRect.height
        )
        
        // set up transforms
        updateTransform()
        
        // update playhead rect
        _playheadRect = CGRect(
            x: playheadPixelPosition - playheadWidth / 2,
            y: 0,
            width: playheadWidth,
            height: frame.height
        )
    }
    
    /**
     Draw call for drawing the entire timeline view.
     */
    override func draw(_ dirtyRect: NSRect) {
        // get the context
        guard let context = NSGraphicsContext.current?.cgContext else {
            return
        }
        
        // get intevals
        let minorInterval = calculateMinorInterval()
        let majorInterval = calculateMajorInterval()
        
        // draw graph
        drawGraph(
            inContext: context,
            inPixelRect: _graphRect,
            withMinorInterval: minorInterval,
            withMajorInterval: majorInterval
        )
        
        // draw meters
        drawMeter(
            inContext: context,
            inPixelRect: _horizontalMeterRect,
            isVertical: false,
            withMinorInterval: minorInterval,
            withMajorInterval: majorInterval
        )
        drawMeter(
            inContext: context,
            inPixelRect: _verticalMeterRect,
            isVertical: true,
            withMinorInterval: minorInterval,
            withMajorInterval: majorInterval
        )
        
        // draw playhead
        drawPlayhead(inContext: context, inPixelRect: _playheadRect)
        
        // reset flags
        _positionChange = false
        _scaleChange = false
        _playheadChange = false
    }
}
