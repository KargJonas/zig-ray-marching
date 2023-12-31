const std = @import("std");
const math = std.math;

const Vec2 = @Vector(2, f32);
const Vec3 = @Vector(3, f32);

pub export fn vecMul2(v: Vec2, factor: f32) Vec2 {
    return Vec2{
        v[0] * factor,
        v[1] * factor,
    };
}

pub export fn vecMul3(v: Vec3, factor: f32) Vec3 {
    return Vec3{
        v[0] * factor,
        v[1] * factor,
        v[2] * factor,
    };
}

pub export fn length3(v: Vec3) f32 {
    return math.sqrt(v[0] * v[0] + v[1] * v[1] + v[2] * v[2]);
}

pub export fn normalize3(v: Vec3) Vec3 {
    return vecMul3(v, 1 / length3(v));
}

pub export fn dot(v: Vec3, w: Vec3) f32 {
    return v[0] * w[0] + v[1] * w[1] + v[2] * w[2];
}

fn fract(x: f32) f32 {
    return x - @floor(x);
}

pub export fn fract3(v: Vec3) Vec3 {
    return Vec3{
        fract(v[0]),
        fract(v[1]),
        fract(v[2]),
    };
}
