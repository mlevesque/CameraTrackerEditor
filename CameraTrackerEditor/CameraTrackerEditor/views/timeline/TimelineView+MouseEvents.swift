//
//  TimelineView+MouseEvents.swift
//  CameraTrackerEditor
//
//  Created by Michael Levesque on 9/3/19.
//  Copyright © 2019 Michael Levesque. All rights reserved.
//

import Cocoa

extension TimelineView {
    /** Enum for indicating which part of the timeline the mouse has clicked
        down on. */
    internal enum MouseTarget {
        case TimeMeter
        case UnitMeter
        case Graph
        case None
    }
    
    /**
     Mouse positioning used in mouse events.
    */
    typealias MousePositioning = (
        pixelPosition: CGPoint,
        pixelPositionCapped: CGPoint,
        unitPositionCapped: CGPoint
    )
    
    /**
     Mouse down event.
     - Parameter event: Mouse event.
    */
    override func mouseDown(with event: NSEvent) {
        // get mouse position information
        let positions = getPositioningFromMouse(fromMouseEvent: event)
        _mouseDownPixelPos = positions.pixelPositionCapped
        _mouseDownUnitPos = positions.unitPositionCapped
        
        // collision check
        _mouseTarget = getMouseTarget(fromPixelPos: positions.pixelPosition)
        
        // call delegates
        switch _mouseTarget {
        case .TimeMeter:
            mouseDelegate?.didMouseDownOnTimeMeter(
                sender: self,
                mouseEvent: event,
                currentPixelLocation: positions.pixelPositionCapped.x,
                currentUnitLocation: positions.unitPositionCapped.x
            )
        case .UnitMeter:
            mouseDelegate?.didMouseDownOnUnitMeter(
                sender: self,
                mouseEvent: event,
                currentPixelLocation: positions.pixelPositionCapped.y,
                currentUnitLocation: positions.unitPositionCapped.y
            )
        case .Graph:
            mouseDelegate?.didMouseDownOnGraph(
                sender: self,
                mouseEvent: event,
                currentPixelLocation: positions.pixelPositionCapped,
                currentUnitLocation: positions.unitPositionCapped
            )
        default:
            break
        }
        mouseDelegate?.didMouseDownOnTimeline(
            sender: self,
            mouseEvent: event,
            currentPixelLocation: positions.pixelPositionCapped,
            currentUnitLocation: positions.unitPositionCapped
        )
    }
    
    /**
     Mouse up event.
     - Parameter event: Mouse event.
    */
    override func mouseUp(with event: NSEvent) {
        // get mouse position information
        let positions = getPositioningFromMouse(fromMouseEvent: event)
        
        // unset drag flag
        _mouseIsDragging = false
        
        // handle the event to the delegate
        switch _mouseTarget {
        case .TimeMeter:
            mouseDelegate?.didMouseUpOnTimeMeter(
                sender: self,
                mouseEvent: event,
                currentPixelLocation: positions.pixelPositionCapped.x,
                currentUnitLocation: positions.unitPositionCapped.x
            )
        case .UnitMeter:
            mouseDelegate?.didMouseUpOnUnitMeter(
                sender: self,
                mouseEvent: event,
                currentPixelLocation: positions.pixelPositionCapped.y,
                currentUnitLocation: positions.unitPositionCapped.y
            )
        case .Graph:
            mouseDelegate?.didMouseUpOnGraph(
                sender: self,
                mouseEvent: event,
                currentPixelLocation: positions.pixelPositionCapped,
                currentUnitLocation: positions.unitPositionCapped
            )
        default:
            break
        }
        mouseDelegate?.didMouseUpOnTimeline(
            sender: self,
            mouseEvent: event,
            currentPixelLocation: positions.pixelPositionCapped,
            currentUnitLocation: positions.unitPositionCapped
        )
        
        // reset target
        _mouseTarget = .None
    }
    
    /**
     Mouse drag event.
     - Parameter event: Mouse event.
     */
    override func mouseDragged(with event: NSEvent) {
        // get current position
        let positions = getPositioningFromMouse(fromMouseEvent: event)
        let mouseDownPixelPos = _mouseDownPixelPos ?? CGPoint(x: 0, y: 0)
        let mouseDownUnitPos = _mouseDownUnitPos ?? CGPoint(x: 0, y: 0)
        
        // set drag flag
        _mouseIsDragging = true
        
        // handle the event to the delegate
        switch _mouseTarget {
        case .TimeMeter:
            mouseDelegate?.didDragOnTimeMeter(
                sender: self,
                mouseEvent: event,
                startPixelLocation: mouseDownPixelPos.x,
                currentPixelLocation: positions.pixelPositionCapped.x,
                startUnitLocation: mouseDownUnitPos.x,
                currentUnitLocation: positions.unitPositionCapped.x
            )
        case .UnitMeter:
            mouseDelegate?.didDragOnUnitMeter(
                sender: self,
                mouseEvent: event,
                startPixelLocation: mouseDownPixelPos.y,
                currentPixelLocation: positions.pixelPositionCapped.y,
                startUnitLocation: mouseDownUnitPos.y,
                currentUnitLocation: positions.unitPositionCapped.y
            )
        case .Graph:
            mouseDelegate?.didDragOnGraph(
                sender: self,
                mouseEvent: event,
                startPixelLocation: mouseDownPixelPos,
                currentPixelLocation: positions.pixelPositionCapped,
                startUnitLocation: mouseDownUnitPos,
                currentUnitLocation: positions.unitPositionCapped
            )
        default:
            break
        }
        mouseDelegate?.didDragOnTimeline(
            sender: self,
            mouseEvent: event,
            startPixelLocation: mouseDownPixelPos,
            currentPixelLocation: positions.pixelPositionCapped,
            startUnitLocation: mouseDownUnitPos,
            currentUnitLocation: positions.unitPositionCapped
        )
    }
    
    /**
     Mouse enter event.
     - Parameter event: Mouse event.
    */
    override func mouseEntered(with event: NSEvent) {
        mouseDelegate?.didMouseEnter(sender: self, mouseEvent: event)
    }
    
    /**
     Mouse exit event.
     - Parameter event: Mouse event.
    */
    override func mouseExited(with event: NSEvent) {
        mouseDelegate?.didMouseExit(sender: self, mouseEvent: event)
    }
    
    /**
     Returns pixel and unit space positions of the mouse from the given mouse
     event.
     - Parameter fromMouseEvent: Mouse event.
    */
    private func getPositioningFromMouse( fromMouseEvent event: NSEvent
                                            ) -> MousePositioning {
        // get pixel position relative to the view
        let pixelPos = convert(event.locationInWindow, from: nil)
        
        // cap the values
        let startPixelPos = startPixelPosition
        let endPixelPos = endPixelPosition
        var pixelPosCapped = CGPoint(
            x: max(pixelPos.x, startPixelPos.x),
            y: max(pixelPos.y, startPixelPos.y)
        )
        pixelPosCapped = CGPoint(
            x: min(pixelPos.x, endPixelPos.x),
            y: min(pixelPos.y, endPixelPos.y)
        )
        
        return (
            pixelPosition: pixelPos,
            pixelPositionCapped: pixelPosCapped,
            unitPositionCapped: pixelPosCapped.applying(pixelToUnitTransform)
        )
    }
    
    /**
     Returns which part of the timeline the given position is over.
     - Parameter fromPixelPos: The position to check, in pixels.
     - Returns: The mouse target.
    */
    private func getMouseTarget(fromPixelPos pos: CGPoint) -> MouseTarget {
        if _graphRect.contains(pos) {
            return .Graph
        }
        else if _horizontalMeterRect.contains(pos) {
            return .TimeMeter
        }
        else if _verticalMeterRect.contains(pos) {
            return .UnitMeter
        }
        else {
            return .None
        }
    }
}
