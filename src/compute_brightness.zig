const sphereSDF = @import("./assets/sphere.zig").sphereSDF;
const vecMul3 = @import("./util/vector.zig").vecMul3;

const max_steps = 300;
const epsilon = 0.3;

pub export fn getBrightness(camera_position: @Vector(3, f32), direction: @Vector(3, f32)) u8 {
    var current_pos = camera_position;

    for (0..max_steps) |_| {
        const dist_from_nearest_object = sphereSDF(current_pos);
        current_pos += vecMul3(direction, dist_from_nearest_object);

        if (dist_from_nearest_object < epsilon) return 255;
    }

    return 0;
}
