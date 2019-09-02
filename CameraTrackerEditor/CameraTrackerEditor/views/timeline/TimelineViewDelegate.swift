//
//  TimelineViewDelegate.swift
//  CameraTrackerEditor
//
//  Created by Michael Levesque on 9/2/19.
//  Copyright © 2019 Michael Levesque. All rights reserved.
//

import Cocoa

protocol TimelineViewDelegate : AnyObject {
    func didClickOnMeter(sender: TimelineViewBase, pixelLocation: CGFloat, unitLocation: CGFloat)
    func didDragOnMeter(sender: TimelineViewBase, pixelLocation: CGFloat, unitLocation: CGFloat)
    func didClickOnTimelineGraph(sender: TimelineViewBase, pixelLocation: CGPoint, unitLocation: CGPoint)
    func didChange(sender: TimelineViewBase, unitToPixelTransform: CGAffineTransform)
}
