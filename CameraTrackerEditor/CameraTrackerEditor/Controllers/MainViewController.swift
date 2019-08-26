//
//  ViewController.swift
//  CameraTrackerEditor
//
//  Created by Michael Levesque on 8/10/19.
//  Copyright © 2019 Michael Levesque. All rights reserved.
//

import Cocoa

class MainViewController: NSViewController {
    
    private var m_openFileIO: DataFileIO?
    private var m_trackingData: TrackingData?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
            }
        } else {
            return
        }
    }

}

