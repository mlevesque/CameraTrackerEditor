//
//  ViewController.swift
//  CameraTrackerEditor
//
//  Created by Michael Levesque on 8/10/19.
//  Copyright © 2019 Michael Levesque. All rights reserved.
//

import Cocoa

class MainViewController: NSViewController {
    private var viewTimeline: TimelineViewController?
    
    private var m_openFileIO: DataFileIO?
    private var m_trackingData: TrackingData?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        switch segue.destinationController {
        case is TimelineViewController:
            viewTimeline = segue.destinationController as? TimelineViewController
            viewTimeline?.setTrackingData(data: m_trackingData)
        default:
            break
        }
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    
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
                m_openFileIO = DataFileIO(url: url)
                let parsedData = try? m_openFileIO?.loadDataModelFromFile()
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

