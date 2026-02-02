# c-time-zig
A Zig wrapper for the C ISO standard `time.h` header, plus thread-safe functions: `ascTimeTS`, `cTimeTS`, `gmTimeTS`, and `localTimeTS`.

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

pub fn main() !void {
    const time: i64 = c_time.time();
    const localtime: c_time.DateTime = try c_time.localTimeTS(time);

    std.debug.print("{d}:{d}:{d}\n", .{ localtime.hour, localtime.min, localtime.sec });
}
```

You can find more examples [here](https://github.com/Samuel-Martin23/c-time-zig/tree/main/examples).

## Disclaimers
- This is my first time writting a Zig wrapper for C. Feel free to report any issues if you notice them. Thanks to everyone on the Zig discord!
- I know there are ongoing efforts to write libc code in Zig, so `c-time-zig` may eventually become obsolete. You can find more information on Andrew's blog [here](https://ziglang.org/devlog/2026/#2026-01-31).
- Also, I decided to use `DateTime` instead of `tm` for improved clarity.