//
//  TimelineViewController.swift
//  CameraTrackerEditor
//
//  Created by Michael Levesque on 8/28/19.
//  Copyright © 2019 Michael Levesque. All rights reserved.
//

import Cocoa

class TimelineViewController : NSViewController {
    private var m_trackingData: TrackingData?
    
    @IBOutlet weak var horizontalMeter: TimelineMeterView!
    @IBOutlet weak var verticalMeter: TimelineMeterView!
    
}
