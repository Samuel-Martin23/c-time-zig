const std: type = @import("std");

const c_time: type = @import("c_time");

pub fn main() !void {
    const time: i64 = c_time.time();
    var buffer: [64]u8 = undefined;

    std.debug.print("{s}", .{try c_time.cTimeTS(time, &buffer)});
}
