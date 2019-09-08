//
//  CustomCursors.swift
//  CameraTrackerEditor
//
//  Created by Michael Levesque on 9/8/19.
//  Copyright © 2019 Michael Levesque. All rights reserved.
//

import Cocoa

/** Cursor for Zoom In Tool. */
let cursorZoomIn = NSCursor(
    image: NSImage(named: NSImage.Name("cursor_zoom_in"))!,
    hotSpot: NSPoint(x: 7, y: 7)
)

/** Cursor for Zoom Out Tool. */
let cursorZoomOut = NSCursor(
    image: NSImage(named: NSImage.Name("cursor_zoom_out"))!,
    hotSpot: NSPoint(x: 7, y: 7)
)
