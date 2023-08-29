const length3 = @import("../util/vector.zig").length3;

const center = @Vector(3, f32){ 0.5, 0.5, 1 };
const radius = 0.4;

// SDF = Signed Distance Function
pub export fn sphereSDF(pos: @Vector(3, f32)) f32 {
    const dist = pos - center;
    return length3(dist) - radius;
}
