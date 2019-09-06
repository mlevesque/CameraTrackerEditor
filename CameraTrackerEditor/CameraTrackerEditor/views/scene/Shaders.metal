//
//  Shaders.metal
//  CameraTrackerEditor
//
//  Created by Michael Levesque on 9/5/19.
//  Copyright © 2019 Michael Levesque. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

// 1
struct VertexIn {
    float4 position [[ attribute(0) ]];
};

// 2
vertex float4 vertex_main(const VertexIn vertexIn [[ stage_in ]],
                          constant float &timer [[ buffer(1) ]]) {
    float4 position = vertexIn.position;
    position.y += timer;
    return position;
}

fragment float4 fragment_main() {
    return float4(1, 0, 0, 1);
}

