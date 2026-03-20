const std: type = @import("std");

const c_time: type = @import("c_time");

pub fn main() void {
    const time: i64 = c_time.time();
    const local_time: c_time.DateTime = c_time.localTimeTS(time) orelse return;

    std.debug.print("{d}:{d}:{d}\n", .{ local_time.hour, local_time.min, local_time.sec });
}
