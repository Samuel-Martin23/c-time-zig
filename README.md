# c-time-zig
A Zig wrapper around the C ISO standard `time.h` header, using the thread-safe implementations of `ascTime`, `cTime`, `gmTime`, and `localTime`.

## Installation
1. Run the following command to add this project as a dependency
```sh
zig fetch --save git+https://github.com/Samuel-Martin23/c-time-zig.git
```

2. In your build.zig, add the following
```zig
const c_time_dep = b.dependency("c_time_zig", .{
    .target = target,
    .optimize = optimize,
});

// Replace `exe` with your actual library or executable
exe.root_module.addImport("c_time", c_time_dep.module("c_time"));
```

## Example
```zig
const std: type = @import("std");

const c_time: type = @import("c_time");

pub fn main() void {
    const time: i64 = c_time.time();
    const date_time: c_time.DateTime = c_time.localTime(time) orelse return;

    std.debug.print("{d}:{d}:{d}\n", .{ date_time.hour, date_time.min, date_time.sec });
}
```

You can find more examples [here](https://github.com/Samuel-Martin23/c-time-zig/tree/main/examples).

## Disclaimer
- I decided to use `DateTime` instead of `tm` for improved clarity.