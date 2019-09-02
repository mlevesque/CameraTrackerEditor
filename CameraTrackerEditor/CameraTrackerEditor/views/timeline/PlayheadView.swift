//
//  PlayheadView.swift
//  CameraTrackerEditor
//
//  Created by Michael Levesque on 9/2/19.
//  Copyright © 2019 Michael Levesque. All rights reserved.
//

import Cocoa

class PlayheadView : NSView {
    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
    }
    
    var position: CGFloat {
        get { return frame.origin.x + frame.width / 2 }
        set(value) { frame.origin.x = value - frame.width / 2 }
    }
    
    override func draw(_ dirtyRect: NSRect) {
        guard let context = NSGraphicsContext.current?.cgContext else {
            return
        }
        
        // draw head
        context.move(to: CGPoint(x: 1.0, y: dirtyRect.maxY - 5))
        context.addLine(to: CGPoint(x: dirtyRect.maxX - 1.0, y: dirtyRect.maxY - 5))
        context.addLine(to: CGPoint(x: dirtyRect.maxX - 1.0, y: dirtyRect.maxY - 12))
        context.addLine(to: CGPoint(x: dirtyRect.maxX / 2, y: dirtyRect.maxY - 20))
        context.addLine(to: CGPoint(x: 1.0, y: dirtyRect.maxY - 12))
        context.addLine(to: CGPoint(x: 1.0, y: dirtyRect.maxY - 5))
        context.setFillColor(CGColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 0.5))
        context.setStrokeColor(CGColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0))
        context.drawPath(using: .fillStroke)
        
        // draw line
        context.move(to: CGPoint(x: dirtyRect.maxX / 2, y: dirtyRect.maxY - 20))
        context.addLine(to: CGPoint(x: dirtyRect.maxX / 2, y: 0))
        context.setStrokeColor(CGColor.init(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0))
        context.drawPath(using: .stroke)
    }
    
    override func hitTest(_ point: NSPoint) -> NSView? {
        // we want to ignore mouse events on the playhead itself
        // because if we don't, then it causes dragging on the timeline meter to stop
        // when we move outside this view if we had started dragging in this view
        return nil
    }
}
