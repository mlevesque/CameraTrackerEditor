//
//  Node.swift
//  CameraTrackerEditor
//
//  Created by Michael Levesque on 9/13/19.
//  Copyright © 2019 Michael Levesque. All rights reserved.
//

import MetalKit

/**
 Base object of all things in a scene.
 */
class Node {
    /** User-facing name for the node. */
    private var _name: String = "Node"
    /** Unique identifier for the node. */
    private var _id: String!
    
    /** Position for node used for the model matrix. */
    private var _position: float3 = float3()
    /** Scale for node used for the model matrix. */
    private var _scale: float3 = float3(1,1,1)
    /** Rotation for node used for the model matrix. */
    private var _rotation: float3 = float3()
    
    /** Parent node in heirarchy. Will be nil if at the top level. */
    private var _parent: Node?
    /** Array of node children in heirarchy. */
    private var _children: [Node] = []
    
    /** Model matrix of the parent node. Will be identity for the top level. */
    internal var parentModelMatrix = matrix_identity_float4x4
    
    
    /**
     Constructor.
    */
    init(name: String = "Node"){
        self._name = name
        self._id = UUID().uuidString
    }

    
    /**
     This should be overriden in subclasses that need an update. This is called before update is called on children
     nodes.
     - Parameter timeStamp: The timestamp of where the scene should be for the tracking data.
    */
    func doUpdateBeforeChildren(timeStamp: Double) {}
    
    /**
     This should be overriden in subclasses that need an update. This is called after update is called on children
     nodes.
     - Parameter timeStamp: The timestamp of where the scene should be for the tracking data.
     */
    func doUpdateAfterChildren(timeStamp: Double) {}
    
    /**
     Updates the node, then its children.
     - Parameter timeStamp: The timestamp of where the scene should be for the tracking data.
    */
    func update(timeStamp: Double) {
        doUpdateBeforeChildren(timeStamp: timeStamp)
        for child in _children{
            child.parentModelMatrix = self.modelMatrix
            child.update(timeStamp: timeStamp)
        }
        doUpdateAfterChildren(timeStamp: timeStamp)
    }
    
    /**
     Performs render operations for the node, if it implements the Renderable protocol, then renders its children.
     - Parameter renderCommandEncoder: The render encoder.
    */
    func render(renderCommandEncoder: MTLRenderCommandEncoder) {
        renderCommandEncoder.pushDebugGroup("Rendering \(_name)")
        if let renderable = self as? Renderable {
            if renderable.shouldRender {
                renderable.doRender(renderCommandEncoder)
            }
        }
        
        for child in _children{
            child.render(renderCommandEncoder: renderCommandEncoder)
        }
        renderCommandEncoder.popDebugGroup()
    }
}

// -- EQUATABLE
extension Node : Equatable {
    static func == (lhs: Node, rhs: Node) -> Bool {
        return lhs._id == rhs._id
    }
}

// -- GETTERS / SETTERS
extension Node {
    var name: String {
        get { return _name }
        set(value) { _name = value }
    }
    
    var id: String { return _id }
    
    var parent: Node? {
        get { return _parent }
        set(n) {
            // remove from old parent
            if let p = _parent, let i = p._children.firstIndex(of: self) {
                p._children.remove(at: i)
            }
            // add to new parent
            _parent = n
            if let p = _parent {
                p._children.append(self)
            }
        }
    }
    
    var modelMatrix: matrix_float4x4 {
        var modelMatrix = matrix_identity_float4x4
        modelMatrix.translate(direction: _position)
        modelMatrix.rotate(angle: _rotation.x, axis: X_AXIS)
        modelMatrix.rotate(angle: _rotation.y, axis: Y_AXIS)
        modelMatrix.rotate(angle: _rotation.z, axis: Z_AXIS)
        modelMatrix.scale(axis: _scale)
        return matrix_multiply(parentModelMatrix, modelMatrix)
    }
    
    // POSITION
    var position: float3 {
        get { return _position }
        set(p) { _position = p }
    }
    var positionX: Float {
        get { return _position.x }
        set(x) { _position.x = x }
    }
    var positionY: Float {
        get { return _position.y }
        set(y) { _position.y = y }
    }
    var positionZ: Float {
        get { return _position.z }
        set(z) { _position.z = z }
    }
    func move(byX x: Float, byY y: Float, byZ z: Float) {move(by: float3(x,y,z))}
    func move(by offset: float3) {_position += offset}
    func moveX(by x: Float) {_position.x += x}
    func moveY(by y: Float) {_position.y += y}
    func moveZ(by z: Float) {_position.z += z}
    
    // ROTATION
    var rotation: float3 {
        get { return _rotation }
        set(r) { _rotation = r }
    }
    var rotationX: Float {
        get { return _rotation.x }
        set(x) { _rotation.x = x }
    }
    var rotationY: Float {
        get { return _rotation.y }
        set(y) { _rotation.y = y }
    }
    var rotationZ: Float {
        get { return _rotation.z }
        set(z) { _rotation.z = z }
    }
    func rotate(byX x: Float, byY y: Float, byZ z: Float) {rotate(by: float3(x,y,z))}
    func rotate(by offset: float3) {_rotation += offset}
    func rotateX(by x: Float) {_rotation.x += x}
    func rotateY(by y: Float) {_rotation.y += y}
    func rotateZ(by z: Float) {_rotation.z += z}
    
    // SCALE
    var scale: float3 {
        get { return _scale }
        set(s) { _scale = s }
    }
    var scaleX: Float {
        get { return _scale.x }
        set(x) { _scale.x = x }
    }
    var scaleY: Float {
        get { return _scale.y }
        set(y) { _scale.y = y }
    }
    var scaleZ: Float {
        get { return _scale.z }
        set(z) { _scale.z = z }
    }
    func scale(byX x: Float, byY y: Float, byZ z: Float) {scale(by: float3(x,y,z))}
    func scale(by offset: float3) {_scale += offset}
    func scaleX(by x: Float) {_scale.x += x}
    func scaleY(by y: Float) {_scale.y += y}
    func scaleZ(by z: Float) {_scale.z += z}
}
