//
//  CGPoint+Operators.swift
//  CameraTrackerEditor
//
//  Created by Michael Levesque on 9/3/19.
//  Copyright © 2019 Michael Levesque. All rights reserved.
//

import Cocoa

/**
 Extending CGPoint to give it operator overload helpers.
 */
extension CGPoint {
    /**
     Allows for a CGSize to be added to a CGPoint like an offset.
     - Parameter lhs: The point that gets updated.
     - Parameter rjs: The size.
    */
    static func += ( lhs: inout CGPoint, rhs: CGSize) {
        lhs = CGPoint(x: lhs.x + rhs.width, y: lhs.y + rhs.height)
    }
    
    /**
     Allows for two CGPoints to be added together to make a new one.
     - Parameter lhs: Left hand point.
     - Parameter rjs: Right hand point.
     - Returns: CGPoint that is the sum of both.
    */
    static func + (lhs: CGPoint, rhs: CGSize) -> CGPoint {
        return CGPoint(x: lhs.x + rhs.width, y: lhs.y + rhs.height)
    }
}
