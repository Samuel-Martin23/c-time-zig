const std: type = @import("std");

const c_time: type = @import("c_time");

pub fn main() void {
    var buffer: [64]u8 = undefined;
    const time: i64 = c_time.time();
    const s: []const u8 = c_time.cTimeTS(&buffer, time) orelse return;

    std.debug.print("{s}", .{s});
}
