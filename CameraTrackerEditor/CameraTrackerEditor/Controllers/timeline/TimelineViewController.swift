//
//  TimelineViewController.swift
//  CameraTrackerEditor
//
//  Created by Michael Levesque on 8/28/19.
//  Copyright © 2019 Michael Levesque. All rights reserved.
//

import Cocoa

class TimelineViewController : NSViewController {
    @IBInspectable var pointerKey: String = "a"
    @IBInspectable var trimKey: String = "t"
    @IBInspectable var zoomKey: String = "z"
    @IBInspectable var handKey: String = "h"
    
    
    /** The tracking data to render in the timeline. */
    internal var _trackingData: TrackingData?
    /** Array of all tool buttons. This helps us update them all for simple
        toggle swapping. */
    internal var _toolButtons: [NSButton] = []
    /** The current tool controller for handling timeline actions upon mouse
        events. */
    internal var _toolController: TimelineViewMouseDelegate?
    
    
    /** reference to the timeline view */
    @IBOutlet var timelineView: TimelineView!
    /** reference to the zoom slider for time. */
    @IBOutlet var zoomTimeSlider: NSSlider!
    /** reference to the label next to the zoom slider for time. */
    @IBOutlet var zoomTimeLabel: NSTextField!
    
    /** Reference to the pointer tool button. */
    @IBOutlet var buttonPointer: NSButton!
    /** Reference to the trim tool button. */
    @IBOutlet var buttonTrim: NSButton!
    /** Reference to the zoom tool button. */
    @IBOutlet var buttonZoom: NSButton!
    /** Reference to the hand tool button. */
    @IBOutlet var buttonHand: NSButton!
    
    /**
     When the view loads. Set it up for rendering.
    */
    override func viewDidLoad() {
        // setup tool buttons
        _toolButtons = [buttonPointer, buttonTrim, buttonZoom, buttonHand]
        buttonPointerClicked()
        
        // setup the view
        timelineView.trackingData = _trackingData
        timelineView.updateTransform()
        timelineView.changeDelegate = self
        
        super.viewDidLoad()
    }
    
    /**
     When the view appears, we will change where the controller is in the
     responder chain. This 
    */
    override func viewDidAppear() {
        if let window = NSApp.windows.first{
            self.nextResponder = window.windowController?.nextResponder
            window.windowController?.nextResponder = self.view
        }
    }
    
    /**
     Sets the tracking data to the given one. This will also pass it to the
     view for rendering and will scale the timeline to fit the data.
     - Parameter data: The data to render in the timeline.
    */
    func setTrackingData(data: TrackingData?) {
        _trackingData = data
        if timelineView != nil {
            timelineView.trackingData = _trackingData
        }
        scaleToFit()
    }
    
    /**
     Makes the timeline redraw.
    */
    func redraw() {
        if let v = timelineView {
            v.setNeedsDisplay(
                v.frame.offsetBy(dx: -v.frame.minX, dy: -v.frame.minY)
            )
        }
    }
    
    /**
     Sets the given controller as the tool controller and sets up delegation
     with the TimelineView.
     - Parameter controller: The controller to set.
    */
    internal func setToolController(_ controller: TimelineViewMouseDelegate) {
        _toolController = controller
        timelineView.mouseDelegate = _toolController
    }
    
    /**
     Updates the slider UI based on the scaling of the timeline.
     */
    internal func updateSliderUI() {
        guard timelineView != nil else {
            return
        }
        
        // get scale from timeline
        let scale = timelineView.scale
        let adjustedScale = CGSize(
            width: 100 / scale.width,
            height: 100 / scale.height
        )
        
        // update slider value
        zoomTimeSlider.doubleValue = Double(adjustedScale.width)
        
        // update slider label
        let nf = NumberFormatter()
        nf.maximumFractionDigits = 0
        let numText = nf.string(
            from: NSNumber(value: Double(adjustedScale.width))
            )!
        zoomTimeLabel.stringValue = "\(numText)%"
    }
}
