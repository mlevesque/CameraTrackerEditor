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
     - Parameter rhs: The size.
    */
    static func += ( lhs: inout CGPoint, rhs: CGSize) {
        lhs = CGPoint(x: lhs.x + rhs.width, y: lhs.y + rhs.height)
    }
    
    /**
     Allows for a CGPoint and a CGSize to be added together to make a new
     CGPoint.
     - Parameter lhs: Left hand CGPoint.
     - Parameter rhs: Right hand CGSize.
     - Returns: CGPoint that is the sum of the operands.
    */
    static func + (lhs: CGPoint, rhs: CGSize) -> CGPoint {
        return CGPoint(x: lhs.x + rhs.width, y: lhs.y + rhs.height)
    }
    
    /**
     Allows a CGSize to be subtracted from a CGPoint and return a new point.
     - Parameter lhs: Left hand CGPoint.
     - Parameter rhs: Right hand CGSize.
     - Returns: CGPoint that is the left operand subtracted from the right
        operand.
     */
    static func - (lhs: CGPoint, rhs: CGSize) -> CGPoint {
        return CGPoint(x: lhs.x - rhs.width, y: lhs.y - rhs.height)
    }
    
    /**
     Allows for two CGPoints to be subtracted together to make a CGSize.
     - Parameter lhs: Left hand point.
     - Parameter rhs: Right hand point.
     - Returns: CGSize that is the difference of both.
    */
    static func - (lhs: CGPoint, rhs: CGPoint) -> CGSize {
        return CGSize(width: lhs.x - rhs.x, height: lhs.y - rhs.y)
    }
    
    /**
     Unary operator to negate a given Point.
     - Parameter rhs: The point to negate.
     - Returns: The negated point.
    */
    static prefix func - (rhs: CGPoint) -> CGPoint {
        return CGPoint(x: -rhs.x, y: -rhs.y)
    }
}
