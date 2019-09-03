//
//  TimelineView+MouseEvents.swift
//  CameraTrackerEditor
//
//  Created by Michael Levesque on 9/3/19.
//  Copyright © 2019 Michael Levesque. All rights reserved.
//

import Cocoa

extension TimelineView {
    /**
     Mouse down event.
     - Parameter event: Mouse event.
    */
    override func mouseDown(with event: NSEvent) {
        // get mouse position information
        let pos = convert(event.locationInWindow, from: nil)
        _mouseDownPixelPos = pos
        _mouseDownUnitPos = pos.applying(pixelToUnitTransform)
        
        // collision check
        _mouseOnHorizontalMeter = _horizontalMeterRect.contains(pos)
        _mouseOnGraph = _graphRect.contains(pos)
    }
    
    /**
     Mouse up event.
     - Parameter event: Mouse event.
    */
    override func mouseUp(with event: NSEvent) {
        // get mouse position information
        let positions = getMousePositioning(fromMouseEvent: event)
        
        // handle the event to the delegate
        if _mouseOnHorizontalMeter {
            delegate?.didClickOnHorizontalMeter(
                sender: self,
                currentPixelLocation: positions.pixelPosition.x,
                currentUnitLocation: positions.unitPosition.x
            )
        }
        else if _mouseOnGraph {
            delegate?.didClickOnTimelineGraph(
                sender: self,
                currentPixelLocation: positions.pixelPosition,
                currentUnitLocation: positions.unitPosition
            )
        }
        
        // reset flags
        _mouseOnHorizontalMeter = false
        _mouseOnGraph = false
    }
    
    /**
     Mouse drag event.
     - Parameter event: Mouse event.
     */
    override func mouseDragged(with event: NSEvent) {
        // get current position
        let positions = getMousePositioning(fromMouseEvent: event)
        
        // handle the event to the delegate
        if _mouseOnHorizontalMeter {
            delegate?.didDragOnHorizontalMeter(
                sender: self,
                startPixelLocation: _mouseDownPixelPos?.x ?? 0,
                currentPixelLocation: positions.pixelPosition.x,
                startUnitLocation: _mouseDownUnitPos?.x ?? 0,
                currentUnitLocation: positions.unitPosition.x
            )
        }
        else if _mouseOnGraph {
            delegate?.didDragOnTimelineGraph(
                sender: self,
                startPixelLocation: _mouseDownPixelPos ?? CGPoint(x: 0, y: 0),
                currentPixelLocation: positions.pixelPosition,
                startUnitLocation: _mouseDownUnitPos ?? CGPoint(x: 0, y: 0),
                currentUnitLocation: positions.unitPosition
            )
        }
    }
    
    /**
     Returns pixel and unit space positions of the mouse from the given mouse
     event.
     - Parameter fromMouseEvent: Mouse event.
    */
    private func getMousePositioning( fromMouseEvent event: NSEvent
                        ) -> (pixelPosition: CGPoint, unitPosition: CGPoint) {
        // get pixel position relative to the view
        var pixelPos = convert(event.locationInWindow, from: nil)
        
        // cap the values
        let startPixelPos = startPixelPosition
        let endPixelPos = endPixelPosition
        pixelPos = CGPoint(
            x: max(pixelPos.x, startPixelPos.x),
            y: max(pixelPos.y, startPixelPos.y)
        )
        pixelPos = CGPoint(
            x: min(pixelPos.x, endPixelPos.x),
            y: min(pixelPos.y, endPixelPos.y)
        )
        
        return (
            pixelPosition: pixelPos,
            unitPosition: pixelPos.applying(pixelToUnitTransform)
        )
    }
}
