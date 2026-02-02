const std: type = @import("std");

const c_time: type = @import("c_time");

pub fn main() !void {
    // Some time consuming code
    for (0..10_000_000) |_| {
        std.debug.print("", .{});
    }

    std.debug.print("{d}\n", .{c_time.clock()});
}
