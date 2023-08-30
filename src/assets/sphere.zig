const vector_lib = @import("../util/vector.zig");
const length3 = vector_lib.length3;
const fract3 = vector_lib.fract3;
const vecMul3 = vector_lib.vecMul3;

const center = @Vector(3, f32){ 0.5, 0.5, 1 };
const radius = 0.5;

// SDF = Signed Distance Function
pub export fn sphereSDF(pos: @Vector(3, f32)) f32 {
    // const dist = fract3(vecMul3(pos, 1)) - center;
    const dist = pos - center;
    return length3(dist) - radius;
}
