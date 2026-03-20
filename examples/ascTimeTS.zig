const std: type = @import("std");

const c_time: type = @import("c_time");

pub fn main() !void {
    var buffer: [64]u8 = undefined;
    const dateTime: c_time.DateTime = c_time.DateTime{
        .year = 124,
        .mon = 0,
        .mday = 1,
        .hour = 12,
        .min = 0,
        .sec = 0,
    };

    std.debug.print("{s}", .{try c_time.ascTimeTS(&buffer, dateTime)});
}
