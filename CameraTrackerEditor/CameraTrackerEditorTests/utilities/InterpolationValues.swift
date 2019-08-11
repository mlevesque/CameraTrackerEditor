//
//  InterpolationValues.swift
//  CameraTrackerEditorTests
//
//  Created by Michael Levesque on 8/11/19.
//  Copyright © 2019 Michael Levesque. All rights reserved.
//

let NearestNeighborTestFloat1 = (
    a: Float(0.0),
    b: Float(1.0),
    tests: [
        (
            t: Float(0.0),
            result: Float(0.0)
        ),
        (
            t: Float(0.25),
            result: Float(0.0)
        ),
        (
            t: Float(0.5),
            result: Float(1.0)
        ),
        (
            t: Float(0.75),
            result: Float(1.0)
        ),
        (
            t: Float(1.0),
            result: Float(1.0)
        )
    ]
)


let LinearTestFloat1 = (
    a: Float(0.0),
    b: Float(1.0),
    tests: [
        (
            t: Float(0.0),
            result: Float(0.0)
        ),
        (
            t: Float(0.25),
            result: Float(0.25)
        ),
        (
            t: Float(0.5),
            result: Float(0.5)
        ),
        (
            t: Float(0.75),
            result: Float(0.75)
        ),
        (
            t: Float(1.0),
            result: Float(1.0)
        )
    ]
)

let LinearTestFloat2 = (
    a: Float(0.0),
    b: Float(-2.0),
    tests: [
        (
            t: Float(0.0),
            result: Float(0.0)
        ),
        (
            t: Float(0.25),
            result: Float(-0.5)
        ),
        (
            t: Float(0.5),
            result: Float(-1.0)
        ),
        (
            t: Float(0.75),
            result: Float(-1.5)
        ),
        (
            t: Float(1.0),
            result: Float(-2.0)
        )
    ]
)

let LinearTestFloat3 = (
    a: Float(1.0),
    b: Float(1.0),
    tests: [
        (
            t: Float(0.0),
            result: Float(1.0)
        ),
        (
            t: Float(0.25),
            result: Float(1.0)
        ),
        (
            t: Float(0.5),
            result: Float(1.0)
        ),
        (
            t: Float(0.75),
            result: Float(1.0)
        ),
        (
            t: Float(1.0),
            result: Float(1.0)
        )
    ]
)


let CubicTestFloat1 = (
    p: (Float(0.0), Float(1.0), Float(1.0), Float(0.0)),
    tests: [
        (
            t: Float(0.0),
            result: Float(1.0)
        ),
        (
            t: Float(0.25),
            result: Float(1.0938)
        ),
        (
            t: Float(0.5),
            result: Float(1.125)
        ),
        (
            t: Float(0.75),
            result: Float(1.0938)
        ),
        (
            t: Float(1.0),
            result: Float(1.0)
        )
    ]
)

let CubicTestFloat2 = (
    p: (Float(0.0), Float(1.0), Float(1.0), Float(2.0)),
    tests: [
        (
            t: Float(0.0),
            result: Float(1.0)
        ),
        (
            t: Float(0.25),
            result: Float(1.0469)
        ),
        (
            t: Float(0.5),
            result: Float(1.0)
        ),
        (
            t: Float(0.75),
            result: Float(0.9531)
        ),
        (
            t: Float(1.0),
            result: Float(1.0)
        )
    ]
)

let CubicTestFloat3 = (
    p: (Float(0.0), Float(1.0), Float(2.0), Float(3.0)),
    tests: [
        (
            t: Float(0.0),
            result: Float(1.0)
        ),
        (
            t: Float(0.25),
            result: Float(1.25)
        ),
        (
            t: Float(0.5),
            result: Float(1.5)
        ),
        (
            t: Float(0.75),
            result: Float(1.75)
        ),
        (
            t: Float(1.0),
            result: Float(2.0)
        )
    ]
)
