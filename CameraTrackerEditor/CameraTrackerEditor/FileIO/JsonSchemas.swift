//
//  JsonSchemas.swift
//  CameraTrackerEditor
//
//  Created by Michael Levesque on 8/12/19.
//  Copyright © 2019 Michael Levesque. All rights reserved.
//

import Foundation

struct TrackingDataJsonSchema: Codable {
    let data: [DataEntryJsonSchema]
}

struct DataEntryJsonSchema: Codable {
    let t: Double
    let px, py, pz: Float
    let rx, ry, rz: Float
}
