//
//  TrackingDataValues.swift
//  CameraTrackerEditorTests
//
//  Created by Michael Levesque on 8/11/19.
//  Copyright © 2019 Michael Levesque. All rights reserved.
//

@testable import CameraTrackerEditor

let SingleEntry = (
    entry: TrackingEntry(
        timeStamp: 0.0,
        position: (x: 0.0, y: 1.0, z: 2.0),
        rotation: (x: 0.0, y: 1.0, z: 2.0)
    ),
    deltaTime: 8.0,
    tests: [
        0.0,
        2.0,
        4.0,
        6.0,
        8.0
    ]
)

let NearestNeighborDoubleEntry = (
    entries: [
        (
            entry: TrackingEntry(
                timeStamp: 0.0,
                position: (x: 0.0, y: 0.0, z: 0.0),
                rotation: (x: 0.0, y: 0.0, z: 0.0)
            ),
            deltaTime: 8.0
        ),
        (
            entry: TrackingEntry(
                timeStamp: 8.0,
                position: (x: 1.0, y: 1.0, z: 1.0),
                rotation: (x: 1.0, y: 1.0, z: 1.0)
            ),
            deltaTime: 1.0
        )
    ],
    tests: [
        (
            t: 0.0,
            result: TrackingEntry(
                timeStamp: 0.0,
                position: (x: 0.0, y: 0.0, z: 0.0),
                rotation: (x: 0.0, y: 0.0, z: 0.0)
            )
        ),
        (
            t: 2.0,
            result: TrackingEntry(
                timeStamp: 2.0,
                position: (x: 0.0, y: 0.0, z: 0.0),
                rotation: (x: 0.0, y: 0.0, z: 0.0)
            )
        ),
        (
            t: 4.0,
            result: TrackingEntry(
                timeStamp: 4.0,
                position: (x: 1.0, y: 1.0, z: 1.0),
                rotation: (x: 1.0, y: 1.0, z: 1.0)
            )
        ),
        (
            t: 6.0,
            result: TrackingEntry(
                timeStamp: 6.0,
                position: (x: 1.0, y: 1.0, z: 1.0),
                rotation: (x: 1.0, y: 1.0, z: 1.0)
            )
        ),
        (
            t: 8.0,
            result: TrackingEntry(
                timeStamp: 8.0,
                position: (x: 1.0, y: 1.0, z: 1.0),
                rotation: (x: 1.0, y: 1.0, z: 1.0)
            )
        ),
    ]
)

let LinearDoubleEntry = (
    entries: [
        (
            entry: TrackingEntry(
                timeStamp: 0.0,
                position: (x: 0.0,  y: 0.0,  z: 0.0),
                rotation: (x: 0.0,  y: 0.0,  z: 0.0)
            ),
            deltaTime: 8.0
        ),
        (
            entry: TrackingEntry(
                timeStamp: 8.0,
                position: (x: 1.0,  y: 2.0,  z: 3.0),
                rotation: (x: -1.0, y: -2.0, z: -3.0)
            ),
            deltaTime: 1.0
        )
    ],
    tests: [
        (
            t: 0.0,
            result: TrackingEntry(
                timeStamp: 0.0,
                position: (x: 0.0,   y: 0.0,   z: 0.0),
                rotation: (x: 0.0,   y: 0.0,   z: 0.0)
            )
        ),
        (
            t: 2.0,
            result: TrackingEntry(
                timeStamp: 2.0,
                position: (x: 0.25,  y: 0.5,   z: 0.75),
                rotation: (x: -0.25, y: -0.5,  z: -0.75)
            )
        ),
        (
            t: 4.0,
            result: TrackingEntry(
                timeStamp: 4.0,
                position: (x: 0.5,   y: 1.0,   z: 1.5),
                rotation: (x: -0.5,  y: -1.0,  z: -1.5)
            )
        ),
        (
            t: 6.0,
            result: TrackingEntry(
                timeStamp: 6.0,
                position: (x: 0.75,  y: 1.5,   z: 2.25),
                rotation: (x: -0.75, y: -1.5,  z: -2.25)
            )
        ),
        (
            t: 8.0,
            result: TrackingEntry(
                timeStamp: 8.0,
                position: (x: 1.0,   y: 2.0,   z: 3.0),
                rotation: (x: -1.0,  y: -2.0,  z: -3.0)
            )
        ),
    ]
)

let CubicDoubleEntry = (
    entries: [
        (
            entry: TrackingEntry(
                timeStamp: 0.0,
                position: (x: 0.0,  y: 0.0,  z: 0.0),
                rotation: (x: 0.0,  y: 0.0,  z: 0.0)
            ),
            deltaTime: 8.0
        ),
        (
            entry: TrackingEntry(
                timeStamp: 8.0,
                position: (x: 1.0,  y: 2.0,  z: 3.0),
                rotation: (x: -1.0, y: -2.0, z: -3.0)
            ),
            deltaTime: 1.0
        )
    ],
    tests: [
        (
            t: -2.0,
            result: TrackingEntry(
                timeStamp: -2.0,
                position: (x: -0.0156,   y: -0.0312,   z: -0.0468),
                rotation: (x: 0.0156,   y: 0.0312,   z: 0.0468)
            )
        ),
        (
            t: 0.0,
            result: TrackingEntry(
                timeStamp: 0.0,
                position: (x: 0.0,   y: 0.0,   z: 0.0),
                rotation: (x: 0.0,   y: 0.0,   z: 0.0)
            )
        ),
        (
            t: 2.0,
            result: TrackingEntry(
                timeStamp: 2.0,
                position: (x: 0.2031,  y: 0.4062,   z: 0.6094),
                rotation: (x: -0.2031, y: -0.4062,  z: -0.6094)
            )
        ),
        (
            t: 4.0,
            result: TrackingEntry(
                timeStamp: 4.0,
                position: (x: 0.5,   y: 1.0,   z: 1.5),
                rotation: (x: -0.5,  y: -1.0,  z: -1.5)
            )
        ),
        (
            t: 6.0,
            result: TrackingEntry(
                timeStamp: 6.0,
                position: (x: 0.7969,  y: 1.5938,   z: 2.3906),
                rotation: (x: -0.7969, y: -1.5938,  z: -2.3906)
            )
        ),
        (
            t: 8.0,
            result: TrackingEntry(
                timeStamp: 8.0,
                position: (x: 1.0,   y: 2.0,   z: 3.0),
                rotation: (x: -1.0,  y: -2.0,  z: -3.0)
            )
        ),
        (
            t: 10.0,
            result: TrackingEntry(
                timeStamp: 10.0,
                position: (x: 1.0156,   y: 2.0312,   z: 3.0468),
                rotation: (x: -1.0156,  y: -2.0312,  z: -3.0468)
            )
        )
    ]
)

let CubicTripleEntry = (
    entries: [
        (
            entry: TrackingEntry(
                timeStamp: 0.0,
                position: (x: 0.0,  y: 0.0,  z: 0.0),
                rotation: (x: 0.0,  y: 0.0,  z: 0.0)
            ),
            deltaTime: 4.0
        ),
        (
            entry: TrackingEntry(
                timeStamp: 4.0,
                position: (x: 1.0,  y: 2.0,  z: 3.0),
                rotation: (x: -1.0, y: -2.0, z: -3.0)
            ),
            deltaTime: 4.0
        ),
        (
            entry: TrackingEntry(
                timeStamp: 8.0,
                position: (x: 0.2,  y: 1.0,  z: 0.8),
                rotation: (x: -0.2, y: -1.0, z: -0.8)
            ),
            deltaTime: 1.0
        )
    ],
    tests: [
        (
            t: -2.0,
            result: TrackingEntry(
                timeStamp: -2.0,
                position: (x: 0.4,   y: 0.6875,   z: 1.1625),
                rotation: (x: -0.4,   y: -0.6875,   z: -1.1625)
            )
        ),
        (
            t: 0.0,
            result: TrackingEntry(
                timeStamp: 0.0,
                position: (x: 0.0,   y: 0.0,   z: 0.0),
                rotation: (x: 0.0,   y: 0.0,   z: 0.0)
            )
        ),
        (
            t: 2.0,
            result: TrackingEntry(
                timeStamp: 2.0,
                position: (x: 0.55,  y: 1.0625,   z: 1.6375),
                rotation: (x: -0.55, y: -1.0625,  z: -1.6375)
            )
        ),
        (
            t: 4.0,
            result: TrackingEntry(
                timeStamp: 4.0,
                position: (x: 1.0,   y: 2.0,   z: 3.0),
                rotation: (x: -1.0,  y: -2.0,  z: -3.0)
            )
        ),
        (
            t: 6.0,
            result: TrackingEntry(
                timeStamp: 6.0,
                position: (x: 0.6625,  y: 1.625,   z: 2.0875),
                rotation: (x: -0.6625, y: -1.625,  z: -2.0875)
            )
        ),
        (
            t: 8.0,
            result: TrackingEntry(
                timeStamp: 8.0,
                position: (x: 0.2,   y: 1.0,   z: 0.8),
                rotation: (x: -0.2,  y: -1.0,  z: -0.8)
            )
        ),
        (
            t: 10.0,
            result: TrackingEntry(
                timeStamp: 10.0,
                position: (x: 0.5875,   y: 1.625,   z: 1.9125),
                rotation: (x: -0.5875,  y: -1.625,  z: -1.9125)
            )
        )
    ]
)

let CubicQuadEntry = (
    entries: [
        (
            entry: TrackingEntry(
                timeStamp: 0.0,
                position: (x: 0.0,  y: 0.0,  z: 0.0),
                rotation: (x: 0.0,  y: 0.0,  z: 0.0)
            ),
            deltaTime: 4.0
        ),
        (
            entry: TrackingEntry(
                timeStamp: 4.0,
                position: (x: 1.0,  y: 2.0,  z: 3.0),
                rotation: (x: -1.0, y: -2.0, z: -3.0)
            ),
            deltaTime: 4.0
        ),
        (
            entry: TrackingEntry(
                timeStamp: 8.0,
                position: (x: 0.2,  y: 1.0,  z: 0.8),
                rotation: (x: -0.2, y: -1.0, z: -0.8)
            ),
            deltaTime: 2.0
        ),
        (
            entry: TrackingEntry(
                timeStamp: 10.0,
                position: (x: 3.2,  y: 2.1,  z: 3.4),
                rotation: (x: -3.2, y: -2.1, z: -3.4)
            ),
            deltaTime: 1.0
        )
    ],
    tests: [
        (
            t: -2.0,
            result: TrackingEntry(
                timeStamp: -2.0,
                position: (x: 0.4,   y: 0.6875,   z: 1.1625),
                rotation: (x: -0.4,   y: -0.6875,   z: -1.1625)
            )
        ),
        (
            t: 0.0,
            result: TrackingEntry(
                timeStamp: 0.0,
                position: (x: 0.0,   y: 0.0,   z: 0.0),
                rotation: (x: 0.0,   y: 0.0,   z: 0.0)
            )
        ),
        (
            t: 2.0,
            result: TrackingEntry(
                timeStamp: 2.0,
                position: (x: 0.55,  y: 1.0625,   z: 1.6375),
                rotation: (x: -0.55, y: -1.0625,  z: -1.6375)
            )
        ),
        (
            t: 4.0,
            result: TrackingEntry(
                timeStamp: 4.0,
                position: (x: 1.0,   y: 2.0,   z: 3.0),
                rotation: (x: -1.0,  y: -2.0,  z: -3.0)
            )
        ),
        (
            t: 6.0,
            result: TrackingEntry(
                timeStamp: 6.0,
                position: (x: 0.475,  y: 1.5562,   z: 1.925),
                rotation: (x: -0.475, y: -1.5562,  z: -1.925)
            )
        ),
        (
            t: 8.0,
            result: TrackingEntry(
                timeStamp: 8.0,
                position: (x: 0.2,   y: 1.0,   z: 0.8),
                rotation: (x: -0.2,  y: -1.0,  z: -0.8)
            )
        ),
        (
            t: 9.0,
            result: TrackingEntry(
                timeStamp: 9.0,
                position: (x: 1.65,   y: 1.4875,   z: 1.9625),
                rotation: (x: -1.65,  y: -1.4875,  z: -1.9625)
            )
        ),
        (
            t: 10.0,
            result: TrackingEntry(
                timeStamp: 10.0,
                position: (x: 3.2,   y: 2.1,   z: 3.4),
                rotation: (x: -3.2,  y: -2.1,  z: -3.4)
            )
        ),
        (
            t: 12.0,
            result: TrackingEntry(
                timeStamp: 12.0,
                position: (x: -3.6,   y: -1.1,   z: -4.0),
                rotation: (x: 3.6,  y: 1.1,  z: 4.0)
            )
        )
    ]
)
