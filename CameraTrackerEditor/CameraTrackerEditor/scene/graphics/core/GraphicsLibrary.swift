//
//  GraphicsLibrary.swift
//  CameraTrackerEditor
//
//  Created by Michael Levesque on 9/14/19.
//  Copyright © 2019 Michael Levesque. All rights reserved.
//

/**
 Library base class for various graphics elements.
 */
class GraphicsLibrary<T,K> {
    /**
     Constructor.
    */
    init() {
        fillLibrary()
    }
    
    /**
     Meant to be overriden to fill of the libarray with whatever the graphics element is.
    */
    func fillLibrary() {
        //Override this function when filling the library with default values
    }
    
    /**
     Accessor for a graphics element of the library.
    */
    subscript(_ type: T) -> K? {
        return nil
    }
}
