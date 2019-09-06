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
     Action when the zoom time slider is changed by the user.
     - Parameter sender: The slider sending the action.
    */
    @IBAction func zoomSliderAction(_ sender: NSSlider) {
        scaleTimeByPercent(sender.doubleValue)
        redraw()
    }
}
