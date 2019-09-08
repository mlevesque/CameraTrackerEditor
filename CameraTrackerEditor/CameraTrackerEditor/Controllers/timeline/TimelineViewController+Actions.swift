//
//  TimelineViewController+Actions.swift
//  CameraTrackerEditor
//
//  Created by Michael Levesque on 9/3/19.
//  Copyright © 2019 Michael Levesque. All rights reserved.
//

import Cocoa

extension TimelineViewController {
    /**
     Updates appearance and state of all tool buttons.
     - Parameter currentSelectedButton: The tool button that is currently
        selected.
    */
    internal func updateToolButtons(currentSelectedButton: NSButton) {
        for button in _toolButtons {
            guard button != currentSelectedButton else {
                continue
            }
            button.state = .off
        }
        currentSelectedButton.state = .on
    }
    
    /**
     Action for when the Pointer tool button is pressed.
     - Parameter sender: The source that the action comes from.
    */
    @IBAction func buttonPointerClicked(_ sender: Any = 0) {
        updateToolButtons(currentSelectedButton: buttonPointer)
        setToolController(TimelinePointerController())
    }
    
    /**
     Action for when the Trim tool button is pressed.
     - Parameter sender: The source that the action comes from.
    */
    @IBAction func buttonTrimClicked(_ sender: Any = 0) {
        updateToolButtons(currentSelectedButton: buttonTrim)
        setToolController(TimelineTrimController())
    }
    
    /**
     Action for when the Zoom tool button is pressed.
     - Parameter sender: The source that the action comes from.
    */
    @IBAction func buttonZoomClicked(_ sender: Any = 0) {
        updateToolButtons(currentSelectedButton: buttonZoom)
        setToolController(TimelineZoomController())
    }
    
    /**
     Action for when the Hand tool button is pressed.
     - Parameter sender: The source that the action comes from.
    */
    @IBAction func buttonHandClicked(_ sender: Any = 0) {
        updateToolButtons(currentSelectedButton: buttonHand)
        setToolController(TimelineHandController())
    }
    
    /**
     Action when the zoom time slider is changed by the user.
     - Parameter sender: The slider sending the action.
    */
    @IBAction func zoomSliderAction(_ sender: NSSlider) {
        scaleTimeByPercent(sender.doubleValue)
        redraw()
    }
}
