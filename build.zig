const std: type = @import("std");

const Example: type = struct {
    name: []const u8,
    path: []const u8,
    desc: []const u8,
};

pub fn build(b: *std.Build) void {
    const target: std.Build.ResolvedTarget = b.standardTargetOptions(.{});
    const optimize: std.builtin.OptimizeMode = b.standardOptimizeOption(.{});

    // Zig wrapper module around time.h:
    // converts headers, macros, and constants into Zig-friendly bindings
    const c_time_header_module: *std.Build.Module = createCTimeHeaderModule(b, target, optimize);

    // Public Zig module exposed to users of this package
    const c_time_module = b.addModule("c_time", .{
        .root_source_file = b.path("src/root.zig"),
        .target = target,
        .optimize = optimize,
    });

    // Make the time.h bindings available as @import("c_time_header")
    c_time_module.addImport("c_time_header", c_time_header_module);

    const lib: *std.Build.Step.Compile = b.addLibrary(.{
        .linkage = .static,
        .name = "c_time",
        .root_module = c_time_module,
    });

    b.installArtifact(lib);

    const examples = [_]Example{
        .{
            .name = "ascTime",
            .path = "examples/ascTime.zig",
            .desc = "Converts a broken-down time into a fixed-format, human-readable string",
        },
        .{
            .name = "ascTimeTS",
            .path = "examples/ascTimeTS.zig",
            .desc = "Thread-safe conversion of a broken-down time into a human-readable string",
        },
        .{
            .name = "clock",
            .path = "examples/clock.zig",
            .desc = "Measures processor time consumed by the program since it started",
        },
        .{
            .name = "cTime",
            .path = "examples/cTime.zig",
            .desc = "Converts calendar time to a readable local date and time string",
        },
        .{
            .name = "cTimeTS",
            .path = "examples/cTimeTS.zig",
            .desc = "Thread-safe conversion of calendar time to a readable date and time string",
        },
        .{
            .name = "diffTime",
            .path = "examples/diffTime.zig",
            .desc = "Computes the elapsed time in seconds between two calendar times",
        },
        .{
            .name = "gmTime",
            .path = "examples/gmTime.zig",
            .desc = "Converts calendar time to a UTC broken-down time structure",
        },
        .{
            .name = "gmTimeTS",
            .path = "examples/gmTimeTS.zig",
            .desc = "Thread-safe conversion of calendar time to a UTC broken-down time structure",
        },
        .{
            .name = "localTime",
            .path = "examples/localTime.zig",
            .desc = "Converts calendar time to a local broken-down time structure",
        },
        .{
            .name = "localTimeTS",
            .path = "examples/localTimeTS.zig",
            .desc = "Thread-safe conversion of calendar time to a local broken-down time structure",
        },
        .{
            .name = "mkTime",
            .path = "examples/mkTime.zig",
            .desc = "Converts a local broken-down time structure into calendar time",
        },
        .{
            .name = "strFormatTime",
            .path = "examples/strFormatTime.zig",
            .desc = "Formats a broken-down time using custom strftime-style format specifiers",
        },
        .{
            .name = "time",
            .path = "examples/time.zig",
            .desc = "Retrieves the current time as seconds since the Unix Epoch",
        },
    };

    inline for (examples) |example| {
        try addExample(b, example, c_time_module, target, optimize);
    }
}

fn createCTimeHeaderModule(
    b: *std.Build,
    target: std.Build.ResolvedTarget,
    optimize: std.builtin.OptimizeMode,
) *std.Build.Module {
    const file: *std.Build.Step.WriteFile = b.addWriteFiles();
    const translate_header: std.Build.LazyPath = file.add("time_wrapper.h",
        \\#include <time.h>
    );

    const translate: *std.Build.Step.TranslateC = b.addTranslateC(.{
        .root_source_file = translate_header,
        .target = target,
        .optimize = optimize,
    });

    const time_module = b.createModule(.{
        .root_source_file = translate.getOutput(),
        .target = target,
        .optimize = optimize,
        .link_libc = true,
    });

    return time_module;
}

fn addExample(
    b: *std.Build,
    comptime example: Example,
    module: *std.Build.Module,
    target: std.Build.ResolvedTarget,
    optimize: std.builtin.OptimizeMode,
) !void {
    const exe = b.addExecutable(.{
        .name = example.name,
        .root_module = b.createModule(.{
            .root_source_file = b.path(example.path),
            .target = target,
            .optimize = optimize,
        }),
    });

    b.installArtifact(exe);

    exe.root_module.addImport("c_time", module);

    const run_step: *std.Build.Step = b.step(std.fmt.comptimePrint("run-{s}", .{example.name}), example.desc);
    run_step.dependOn(&b.addRunArtifact(exe).step);
}
