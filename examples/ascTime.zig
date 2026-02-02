const std: type = @import("std");

const c_time: type = @import("c_time");

pub fn main() !void {
    const s: []const u8 = c_time.ascTime(.{
        .year = 124,
        .mon = 0,
        .mday = 1,
        .hour = 12,
        .min = 0,
        .sec = 0,
    });

    std.debug.print("{s}", .{s});
}
