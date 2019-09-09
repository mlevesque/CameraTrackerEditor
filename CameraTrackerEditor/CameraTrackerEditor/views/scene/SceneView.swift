//
//  SceneView.swift
//  CameraTrackerEditor
//
//  Created by Michael Levesque on 9/9/19.
//  Copyright © 2019 Michael Levesque. All rights reserved.
//

import MetalKit

class SceneView : MTKView {
    
    struct Vertex {
        var position: float3
        var color: float4
    }
    
    var commandQueue: MTLCommandQueue!
    var renderPipelineState: MTLRenderPipelineState!
    
//    let vertices: [float3] = [
//        float3( 0, 1, 0),
//        float3(-1,-1, 0),
//        float3( 1,-1, 0)
//    ]
    
    let vertices: [Vertex] = [
        Vertex(position: float3( 0, 1, 0), color: float4(1,0,0,1)),
        Vertex(position: float3(-1,-1, 0), color: float4(0,1,0,1)),
        Vertex(position: float3( 1,-1, 0), color: float4(0,0,1,1))
    ]
    
    var vertexBuffer: MTLBuffer!
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        
        self.device = MTLCreateSystemDefaultDevice()
        self.clearColor = MTLClearColor(
            red: 0.0,
            green: 0.0,
            blue: 0.0,
            alpha: 1.0
        )
        self.colorPixelFormat = .bgra8Unorm
        self.commandQueue = device?.makeCommandQueue()
        
        createRenderPipelineState()
        createBuffers()
    }
    
    func createBuffers() {
        vertexBuffer = device?.makeBuffer(
            bytes: vertices,
            length: MemoryLayout<Vertex>.stride * vertices.count,
            options: []
        )
    }
    
    func createRenderPipelineState() {
        let library = device?.makeDefaultLibrary()
        let vertexFunction = library?.makeFunction(name: "vertex_main")
        let fragmentFunction = library?.makeFunction(name: "fragment_main")
        
        let renderPipelineDescriptor = MTLRenderPipelineDescriptor()
        renderPipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        renderPipelineDescriptor.vertexFunction = vertexFunction
        renderPipelineDescriptor.fragmentFunction = fragmentFunction
        
        do {
            renderPipelineState = try device?.makeRenderPipelineState(
                descriptor: renderPipelineDescriptor
            )
        }
        catch let error as NSError {
            print(error)
        }
    }
    
    override func draw(_ dirtyRect: NSRect) {
        guard let drawable = self.currentDrawable,
              let renderPassDescriptor = self.currentRenderPassDescriptor
            else {
                return
        }
        
        let commandBuffer = commandQueue.makeCommandBuffer()
        let renderCommandEncoder = commandBuffer?.makeRenderCommandEncoder(
            descriptor: renderPassDescriptor
        )
        renderCommandEncoder?.setRenderPipelineState(renderPipelineState)
        
        renderCommandEncoder?.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        renderCommandEncoder?.drawPrimitives(
            type: .triangle,
            vertexStart: 0,
            vertexCount: vertices.count
        )
        
        renderCommandEncoder?.endEncoding()
        commandBuffer?.present(drawable)
        commandBuffer?.commit()
    }
}
