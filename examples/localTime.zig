const std: type = @import("std");

const c_time: type = @import("c_time");

pub fn main() !void {
    const time: i64 = c_time.time();
    const localtime: c_time.DateTime = c_time.localTime(time);

    std.debug.print("{d}:{d}:{d}\n", .{ localtime.hour, localtime.min, localtime.sec });
}
