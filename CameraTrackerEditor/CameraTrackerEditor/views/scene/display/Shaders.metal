//
//  Shaders.metal
//  CameraTrackerEditor
//
//  Created by Michael Levesque on 9/5/19.
//  Copyright © 2019 Michael Levesque. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

/**
 Input for the vertex shader. This should match the Vertex struct defined in Vertex.swift.
 */
struct VertexIn {
    float3 position [[ attribute(0) ]];
    float4 color [[ attribute(1) ]];
};

/**
 Output from vertex shader and input for fragment shader.
 */
struct RasterizerData {
    float4 position [[ position ]];
    float4 color;
};


/**
 Basic vertex shader. Nothing special.
 */
vertex RasterizerData vertex_basic(const VertexIn vIn [[ stage_in ]]) {
    RasterizerData data;
    data.position = float4(vIn.position, 1);
    data.color = vIn.color;
    return data;
}

/**
 Basic fragment shader. Nothing special.
 */
fragment half4 fragment_basic(RasterizerData data [[ stage_in ]]) {
    float4 color = data.color;
    return half4(color.r, color.g, color.b, color.a);
}

