//
//  ModelBuilder.swift
//  CameraTrackerEditor
//
//  Created by Michael Levesque on 8/28/19.
//  Copyright © 2019 Michael Levesque. All rights reserved.
//

import Foundation

func buildModelFromSchema(schema: TrackingDataJsonSchema) -> TrackingData {
    let model = TrackingData()
    for entry in schema.data {
        model.pushEntry(
            deltaTime: entry.t,
            position: Vec3(entry.px, entry.py, entry.pz),
            rotation: Vec3(entry.rx, entry.ry, entry.rz)
        )
    }
    return model
}
