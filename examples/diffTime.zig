const std: type = @import("std");

const c_time: type = @import("c_time");

pub fn main() !void {
    const time_1: i64 = c_time.time();

    // Some time consuming code
    for (0..50_000_000) |_| {
        std.debug.print("", .{});
    }

    const time_2: i64 = c_time.time();

    std.debug.print("{d}\n", .{c_time.diffTime(time_2, time_1)});
}
