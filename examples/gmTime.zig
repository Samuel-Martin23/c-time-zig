const std: type = @import("std");

const c_time: type = @import("c_time");

pub fn main() !void {
    const time: i64 = c_time.time();
    std.debug.print("{d}", .{c_time.gmTime(time).hour});
}
