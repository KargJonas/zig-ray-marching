// build with `zig build-exe cimport.zig -lc -lraylib`
const ray = @cImport({
    @cInclude("raylib.h");
});

const std = @import("std");
const getColor = @import("./compute_brightness.zig").getColor;
const normalize3 = @import("./util/vector.zig").normalize3;

// CONFIG //
const camera_position = @Vector(3, f32){ 0.5, 0.5, 0 };
const cell_size = 0.01;
const focal_length = 1;
const width = 700;
const height = 500;
// CONFIG END //

// const neighborhood = [_]@Vector(2, f32) {

// }

pub fn main() void {
    ray.InitWindow(width, height, "Zig Raymarching");
    ray.SetTargetFPS(60);
    defer ray.CloseWindow();

    while (!ray.WindowShouldClose()) {
        ray.BeginDrawing();
        defer ray.EndDrawing();

        var x: f32 = -1.0;
        var y: f32 = -1.0;

        while (x <= 1.0) {
            y = -1.0;
            defer x += cell_size;

            while (y <= 1.0) {
                defer y += cell_size;

                const current_pixel = @Vector(2, f32){ x, y };
                const direction_raw = @Vector(3, f32){
                    current_pixel[0] / focal_length,
                    current_pixel[1] / focal_length,
                    focal_length,
                };

                const camera_direction = normalize3(direction_raw);
                const light_direction = @Vector(3, f32){
                    @floatCast(@sin(ray.GetTime())),
                    @floatCast(@cos(ray.GetTime())),
                    0,
                };
                // const light_direction = @Vector(3, f32){ 0.5, 0.5, 0 };
                const color = getColor(camera_position, camera_direction, light_direction);

                const abs_pixel_x = (x + 1) / 2 * width;
                const abs_pixel_y = (y + 1) / 2 * height;

                ray.DrawRectangle(@intFromFloat(abs_pixel_x), @intFromFloat(abs_pixel_y), cell_size * width, cell_size * height, .{ color[0], color[1], color[2], 255 });
            }
        }
    }
}
