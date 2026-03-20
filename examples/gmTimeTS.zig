const std: type = @import("std");

const c_time: type = @import("c_time");

pub fn main() void {
    const time: i64 = c_time.time();
    const date_time: c_time.DateTime = c_time.gmTimeTS(time) orelse return;

    std.debug.print("{d}", .{date_time.hour});
}
