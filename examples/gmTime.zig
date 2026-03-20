const std: type = @import("std");

const c_time: type = @import("c_time");

pub fn main() void {
    const time: i64 = c_time.time();
    const datatime: c_time.DateTime = c_time.gmTime(time) orelse return;

    std.debug.print("{d}\n", .{datatime.hour});
}
