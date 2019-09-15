//
//  InstancedObjectNode.swift
//  CameraTrackerEditor
//
//  Created by Michael Levesque on 9/15/19.
//  Copyright © 2019 Michael Levesque. All rights reserved.
//

import MetalKit

/**
 Object Node with an instanced mesh.
 */
class InstancedObjectNode : Node {
    /** Flag indicating if node should be rendered. */
    private var _shouldRender: Bool = true
    
    /** The instanced mesh. */
    private var _mesh: Mesh!
    
    /** Mesh material */
    var material = Material()
    
    /** Nodes for each mesh instance. These nodes are not in the scene hierarchy and mainly serve for giving each
        instance a position, orientation, and scale. */
    internal var _nodes: [Node] = []
    /** Constant Buffer for the model constants. */
    private var _modelConstantBuffer: MTLBuffer!
    
    /**
     Constructor.
    */
    init(meshType: MeshTypes, instanceCount: Int) {
        super.init(name: "Instanced Object Node")
        self._mesh = Entities.Meshes[meshType]
        self._mesh.setInstanceCount(instanceCount)
        self.generateInstances(instanceCount)
        self.createBuffers(instanceCount)
    }
    
    /**
     Creates all the nodes that represents each instance.
     - Parameter instanceCount: The number of instances for the mesh of this object.
    */
    func generateInstances(_ instanceCount: Int){
        for _ in 0..<instanceCount {
            _nodes.append(Node())
        }
    }
    
    /**
     Creates the buffer for the model constant instances.
     - Parameter instanceCount: The number of instances for the mesh of this object.
    */
    func createBuffers(_ instanceCount: Int) {
        _modelConstantBuffer = SceneEngine.device.makeBuffer(length: ModelConstants.stride(instanceCount), options: [])
    }
    
    /**
     Updates the model matrices of each instance in the buffer.
    */
    private func updateModelConstantsBuffer() {
        var pointer = _modelConstantBuffer.contents().bindMemory(to: ModelConstants.self, capacity: _nodes.count)
        for node in _nodes {
            pointer.pointee.modelMatrix = matrix_multiply(self.modelMatrix, node.modelMatrix)
            pointer = pointer.advanced(by: 1)
        }
    }
    
    /**
     Update the model constants.
     - Parameter timeStamp: The tracking data current timestamp.
    */
    override func doUpdateBeforeChildren(timeStamp: Double) {
        updateModelConstantsBuffer()
    }
}

extension InstancedObjectNode : Renderable {
    /** Whether or not the node should be rendered. */
    var shouldRender: Bool {
        get { return _shouldRender }
        set(value) { _shouldRender = value }
    }
    
    /**
     Performs instanced rendering.
     - Parameter renderCommandEncoder: The command encoder for rendering.
    */
    func doRender(_ renderCommandEncoder: MTLRenderCommandEncoder) {
        renderCommandEncoder.setRenderPipelineState(Graphics.renderPipelineStates[.instanced])
        //renderCommandEncoder.setDepthStencilState(Graphics.depthStencilStates[.less])
        
        // vertex Shader
        renderCommandEncoder.setVertexBuffer(_modelConstantBuffer, offset: 0, index: 2)
        
        // fragment Shader
        renderCommandEncoder.setFragmentBytes(&material, length: Material.stride, index: 1)
        
        _mesh.drawPrimitives(renderCommandEncoder)
    }
}

//Material Properties
extension InstancedObjectNode {
    public func setColor(_ color: float4){
        self.material.color = color
        self.material.useMaterialColor = true
    }
}

