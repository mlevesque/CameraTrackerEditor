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
     - Parameter sender: The button that the action comes from.
    */
    @IBAction func buttonPointerClicked(_ sender: NSButton) {
        updateToolButtons(currentSelectedButton: sender)
        setToolController(TimelinePointerController())
    }
    
    /**
     Action for when the Trim tool button is pressed.
     - Parameter sender: The button that the action comes from.
    */
    @IBAction func buttonTrimClicked(_ sender: NSButton) {
        updateToolButtons(currentSelectedButton: sender)
        setToolController(TimelineTrimController())
    }
    
    /**
     Action for when the Zoom tool button is pressed.
     - Parameter sender: The button that the action comes from.
    */
    @IBAction func buttonZoomClicked(_ sender: NSButton) {
        updateToolButtons(currentSelectedButton: sender)
        setToolController(TimelineZoomController())
    }
    
    /**
     Action for when the Hand tool button is pressed.
     - Parameter sender: The button that the action comes from.
    */
    @IBAction func buttonHandClicked(_ sender: NSButton) {
        updateToolButtons(currentSelectedButton: sender)
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
    
    
    /**
     Allows this to accept first responder for keyboard presses.
     - Returns: true
    */
    override var acceptsFirstResponder : Bool {
        return true
    }

    /**
     Allows for the keys we need to be listened for.
     - Parameter event: The keyboard event.
     - Returns: True if the key is accepted. False if not.
    */
    override func performKeyEquivalent(with event: NSEvent) -> Bool {
        return true
    }

    /**
     Triggered when an acceptable key is pressed. Will perform the appropriate
     action.
     - Parameter event: The keyboard event.
    */
    override func keyUp(with event: NSEvent) {
        switch event.characters {
        case pointerKey:
            buttonPointerClicked(buttonPointer)
        case trimKey:
            buttonTrimClicked(buttonTrim)
        case zoomKey:
            buttonZoomClicked(buttonZoom)
        case handKey:
            buttonHandClicked(buttonHand)
        default:
            return
        }
    }
}
