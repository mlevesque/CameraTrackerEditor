//
//  MainView.swift
//  CameraTrackerEditor
//
//  Created by Michael Levesque on 9/7/19.
//  Copyright © 2019 Michael Levesque. All rights reserved.
//

import Cocoa

/**
 Main view attached to the main controller.
*/
class MainView : NSView {
    /**
     This prevents the "funk" sound from playing when a key is pressed.
     - Parameter event: The keyboard event.
     - Returns: true
    */
    override func performKeyEquivalent(with event: NSEvent) -> Bool {
        return true
    }
}
