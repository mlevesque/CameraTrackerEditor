//
//  TimelineViewController - TimelineViewDelegate.swift
//  CameraTrackerEditor
//
//  Created by Michael Levesque on 9/2/19.
//  Copyright © 2019 Michael Levesque. All rights reserved.
//

import Cocoa

extension TimelineViewController : TimelineViewChangeDelegate {
    /**
     Called when the timeline position changes.
     - Parameter sender: The TimelineView that called this.
     - Parameter previousPixelPosition: The previous starting position in pixel
        space of the timeline before the change.
     - Parameter previousUnitPosition: The previous starting position in unit
        space of the timeline before the change.
     - Parameter currentPixelPosition: The current starting position in pixel
        space of the timeline after the change.
     - Parameter currentUnitPosition: The current starting position in unit
        space of the timeline after the change.
    */
    func didPositionChange( sender: TimelineView,
                            previousPixelPosition: CGPoint,
                            previousUnitPosition: CGPoint,
                            currentPixelPosition: CGPoint,
                            currentUnitPosition: CGPoint) {
        redraw()
    }
    
    /**
     Called when the timeline scale changes.
     - Parameter sender: The TimelineView that called this.
     - Parameter previousScale: The previous scale of the timeline before the
        change.
     - Parameter currentScale: The current scale of the timeline after the
        change.
    */
    func didScaleChange( sender: TimelineView,
                         previousScale: CGSize,
                         currentScale: CGSize) {
        updateSliderUI()
        redraw()
    }
    
    /**
     Called when the playhead in the timeline changes.
     - Parameter sender: The TimelineView that called this.
     - Parameter previousPixelLocation: The previous playhead location in pixel
        space in the timeline before the change.
     - Parameter previousUnitLocation: The previous playhead location in unit
        space in the timeline before the change.
     - Parameter currentPixelLocation: The current playhead location in pixel
        space in the timeline after the change.
     - Parameter currentUnitLocation: The current playhead location in unit
        space in the timeline after the change.
    */
    func didPlayheadChange( sender: TimelineView,
                            previousPixelLocation: CGFloat,
                            previousUnitLocation: CGFloat,
                            currentPixelLocation: CGFloat,
                            currentUnitLocation: CGFloat) {
        redraw()
    }
    
    
}
