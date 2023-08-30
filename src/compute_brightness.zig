const ray = @cImport({
    @cInclude("raylib.h");
});

const std = @import("std");
const math = std.math;
const sphereSDF = @import("./assets/sphere.zig").sphereSDF;
const vector_lib = @import("./util/vector.zig");
const vecMul3 = vector_lib.vecMul3;
const dot = vector_lib.dot;
const normalize3 = vector_lib.normalize3;

// const Color = std.meta.Tuple(&.{ u8, u8, u8, u8 });

const max_steps = 300;
const epsilon = 0.3;
const step_size = 0.7; // prevents overstepping
const neighbor_spread = 0.01;

const light_direction = @Vector(3, f32){ 0.5, 0.5, 0 };

pub export fn getColor(camera_position: @Vector(3, f32), direction: @Vector(3, f32)) @Vector(3, u8) {
    const normal = getSurfaceNormal(camera_position, direction);
    // const reflected_light = dot(normal, light_direction);

    const r: u8 = @intFromFloat(@fabs(@min(normal[0] / 10000, 255)));
    const g: u8 = @intFromFloat(@fabs(@min(normal[1] / 10000, 255)));
    const b: u8 = @intFromFloat(@fabs(@min(normal[2] / 10000, 255)));

    return @Vector(3, u8){ r, g, b };
}

pub export fn getSurfaceNormal(camera_position: @Vector(3, f32), direction: @Vector(3, f32)) @Vector(3, f32) {
    const perturb_x = @Vector(3, f32){ neighbor_spread, 0, 0 };
    const perturb_y = @Vector(3, f32){ 0, neighbor_spread, 0 };
    const perturb_z = @Vector(3, f32){ 0, 0, neighbor_spread };

    const normal = normalize3(@Vector(3, f32){
        getDistanceToObject(camera_position + perturb_x, direction) - getDistanceToObject(camera_position - perturb_x, direction),
        getDistanceToObject(camera_position + perturb_y, direction) - getDistanceToObject(camera_position - perturb_y, direction),
        getDistanceToObject(camera_position + perturb_z, direction) - getDistanceToObject(camera_position - perturb_y, direction),
    });

    return normal;
}

pub export fn getDistanceToObject(camera_position: @Vector(3, f32), direction: @Vector(3, f32)) f32 {
    var current_pos = camera_position;
    var total_distance: f32 = 0;

    for (0..max_steps) |_| {
        const dist_from_nearest_object = sphereSDF(current_pos);
        current_pos += vecMul3(direction, dist_from_nearest_object * step_size);
        total_distance += dist_from_nearest_object;

        if (dist_from_nearest_object < epsilon) return total_distance;
    }

    // TODO: Think about returning negative values as indicator that
    //   the max depth was reached.
    // return total_distance;
    return total_distance;
}
