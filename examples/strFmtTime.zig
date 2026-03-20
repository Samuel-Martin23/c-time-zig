const std: type = @import("std");

const c_time: type = @import("c_time");

pub fn main() void {
    var buffer: [64]u8 = undefined;
    const date_time: c_time.DateTime = c_time.DateTime{
        .year = 124,
        .mon = 0,
        .mday = 1,
        .hour = 12,
        .min = 0,
        .sec = 0,
    };

    const s: []const u8 = c_time.strFmtTime(&buffer, "%Y-%m-%d %H:%M", date_time) orelse return;
    std.debug.print("{s}\n", .{s});
}
