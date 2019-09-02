//
//  TimelineViewController - TimelineViewDelegate.swift
//  CameraTrackerEditor
//
//  Created by Michael Levesque on 9/2/19.
//  Copyright © 2019 Michael Levesque. All rights reserved.
//

import Cocoa

extension TimelineViewController : TimelineViewDelegate {
    func didClickOnMeter(sender: TimelineViewBase, pixelLocation: CGFloat, unitLocation: CGFloat) {
        positionPlayhead(atPixelLocation: pixelLocation)
    }
    
    func didDragOnMeter(sender: TimelineViewBase, pixelLocation: CGFloat, unitLocation: CGFloat) {
        positionPlayhead(atPixelLocation: pixelLocation)
    }
    
    func didChange(sender: TimelineViewBase, unitToPixelTransform: CGAffineTransform) {
    }
    
    func didClickOnTimelineGraph(sender: TimelineViewBase, pixelLocation: CGPoint, unitLocation: CGPoint) {
    }
    
    func positionPlayhead(atPixelLocation pixelLocation: CGFloat) {
        let adjustedPixelLocation = horizontalMeter!.convert(
            CGPoint(x: pixelLocation, y: 0.0),
            to: self.view
        ).x
        playhead.position = adjustedPixelLocation
    }
    
    func positionPlayhead(atUnitLocation unitLocation: CGFloat) {
        let pos = CGPoint(
            x: horizontalMeter!.getPixelPosition(fromUnitPosition: unitLocation),
            y: 0.0
        )
        let adjustedPixelLocation = horizontalMeter!.convert(
            pos,
            to: self.view
        ).x
        playhead.position = adjustedPixelLocation
    }
}
