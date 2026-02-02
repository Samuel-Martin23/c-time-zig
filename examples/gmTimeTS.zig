const std: type = @import("std");

const c_time: type = @import("c_time");

pub fn main() !void {
    const time: i64 = c_time.time();
    const dateTime: c_time.DateTime = try c_time.gmTimeTS(time);

    std.debug.print("{d}", .{dateTime.hour});
}
