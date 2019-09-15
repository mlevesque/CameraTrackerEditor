//
//  TrackingDataManager.swift
//  CameraTrackerEditor
//
//  Created by Michael Levesque on 9/14/19.
//  Copyright © 2019 Michael Levesque. All rights reserved.
//

import Foundation

class TrackingDataManager {
    private static var _originalData: TrackingData?
    private static var _currentData: TrackingData?
    
    public static var originalData: TrackingData? { return _originalData }
    public static var currentData: TrackingData? { return _currentData }
    
    public static func setCurrentData(_ data: TrackingData?) {
        _currentData = data
    }
    
    public static func setOriginalData(_ data: TrackingData) {
        _originalData = data
        _currentData = data
    }
}
