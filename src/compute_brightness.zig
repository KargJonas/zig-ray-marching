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

const max_steps = 100;
const epsilon = 0.0001;
const step_size = 0.9; // prevents overstepping
const neighbor_spread = 0.01;

// Maps a float 32 in range [-1.0, 1.0] to a u8 in range [0, 255]
fn mapFloatToU8(x: f32) u8 {
    const scaled = x * 255;
    const capped = @max(@min(scaled, 255), 0);
    return @intFromFloat(capped);
}

pub export fn getColor(camera_position: @Vector(3, f32), camera_direction: @Vector(3, f32), light_direction: @Vector(3, f32)) @Vector(3, u8) {
    const normal = getSurfaceNormal(camera_position, camera_direction);
    const reflected_light = dot(normal, light_direction);
    const b = mapFloatToU8((reflected_light + 1) / 2);

    return @Vector(3, u8){ b, b, b };
}

pub export fn getSurfaceNormal(camera_position: @Vector(3, f32), camera_direction: @Vector(3, f32)) @Vector(3, f32) {
    const perturb_x = @Vector(3, f32){ neighbor_spread, 0, 0 };
    const perturb_y = @Vector(3, f32){ 0, neighbor_spread, 0 };
    const perturb_z = @Vector(3, f32){ 0, 0, neighbor_spread };

    const normal = normalize3(@Vector(3, f32){
        getDistanceToObject(camera_position + perturb_x, camera_direction) - getDistanceToObject(camera_position - perturb_x, camera_direction),
        getDistanceToObject(camera_position + perturb_y, camera_direction) - getDistanceToObject(camera_position - perturb_y, camera_direction),
        getDistanceToObject(camera_position + perturb_z, camera_direction) - getDistanceToObject(camera_position - perturb_y, camera_direction),
    });

    return normal;
}

pub export fn getDistanceToObject(camera_position: @Vector(3, f32), camera_direction: @Vector(3, f32)) f32 {
    var current_pos = camera_position;
    var total_distance: f32 = 0;

    for (0..max_steps) |_| {
        const dist_from_nearest_object = sphereSDF(current_pos);
        current_pos += vecMul3(camera_direction, dist_from_nearest_object * step_size);
        total_distance += dist_from_nearest_object;

        if (dist_from_nearest_object < epsilon) return total_distance;
    }

    // TODO: Think about returning negative values as indicator that
    //   the max depth was reached.
    // return total_distance;
    return total_distance;
}
