//
//  Shaders.metal
//  CameraTrackerEditor
//
//  Created by Michael Levesque on 9/5/19.
//  Copyright © 2019 Michael Levesque. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

struct VertexIn {
    float3 position;
    float4 color;
};

struct RasterizerData {
    float4 position [[ position ]];
    float4 color;
};

vertex RasterizerData vertex_main(device VertexIn *vertices [[ buffer(0) ]],
                          uint vertexID [[ vertex_id ]]) {
    RasterizerData data;
    data.position = float4(vertices[vertexID].position, 1);
    data.color = vertices[vertexID].color;
    return data;
}

fragment half4 fragment_main(RasterizerData data [[ stage_in ]]) {
    float4 color = data.color;
    return half4(color.r, color.g, color.b, color.a);
}

