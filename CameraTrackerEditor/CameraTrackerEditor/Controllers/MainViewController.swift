//
//  ViewController.swift
//  CameraTrackerEditor
//
//  Created by Michael Levesque on 8/10/19.
//  Copyright © 2019 Michael Levesque. All rights reserved.
//

import Cocoa

/**
 Controller for the main view.
 */
class MainViewController: NSViewController {
    /** Reference to the TimelineViewController. */
    private var viewTimeline: TimelineViewController?
    
    /** The loaded tracking data. */
    private var m_trackingData: TrackingData?
    
    /**
     Called when view controllers are embredded into this view controller.
     - Parameter segue: The embed segue.
     - Parameter sender: The source of the call.
    */
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        switch segue.destinationController {
        case is TimelineViewController:
            viewTimeline
                = segue.destinationController as? TimelineViewController
            viewTimeline?.setTrackingData(data: m_trackingData)
        default:
            break
        }
    }
    
    /**
     Open document action. Opens a tracking data file and parses it.
    */
    @IBAction func openDocument(_ sender: Any?) {
        let dialog = NSOpenPanel();

        dialog.title                   = "Choose a tracker json file";
        dialog.showsResizeIndicator    = true;
        dialog.showsHiddenFiles        = false;
        dialog.canChooseDirectories    = true;
        dialog.canCreateDirectories    = true;
        dialog.allowsMultipleSelection = false;
        dialog.allowedFileTypes        = ["json"]

        if (dialog.runModal() == NSApplication.ModalResponse.OK) {
            if let url = dialog.url {
                 let openFileIO = DataFileIO(url: url)
                let parsedData = try? openFileIO.loadDataModelFromFile()
                if let data = parsedData {
                    m_trackingData = buildModelFromSchema(schema: data)
                    viewTimeline?.setTrackingData(data: m_trackingData!)
                }
            }
        } else {
            return
        }
    }
}
