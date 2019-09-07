//
//  CGSize+Operators.swift
//  CameraTrackerEditor
//
//  Created by Michael Levesque on 9/7/19.
//  Copyright © 2019 Michael Levesque. All rights reserved.
//

import Cocoa

extension CGSize {
    /**
     Multiplication operator between a CGSize and a scalar.
     - Parameter lhs: The CGSize
     - Parameter rhs: The scalar value.
    */
    static func * (lhs: CGSize, rhs: CGFloat) -> CGSize {
        return CGSize(width: lhs.width * rhs, height: lhs.height * rhs)
    }
    
    /**
     Division operator between a CGSize and a scalar.
     - Parameter lhs: The CGSize
     - Parameter rhs: The scalar value.
     */
    static func / (lhs: CGSize, rhs: CGFloat) -> CGSize {
        return CGSize(width: lhs.width / rhs, height: lhs.height / rhs)
    }
}
