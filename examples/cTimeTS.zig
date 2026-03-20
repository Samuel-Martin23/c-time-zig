const std: type = @import("std");

const c_time: type = @import("c_time");

pub fn main() !void {
    var buffer: [64]u8 = undefined;
    const time: i64 = c_time.time();

    std.debug.print("{s}", .{try c_time.cTimeTS(&buffer, time)});
}
