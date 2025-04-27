const std = @import("std");

// Although this function looks imperative, note that its job is to
// declaratively construct a build graph that will be executed by an external
// runner.
pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});
    const opt_use_shared = b.option(bool, "shared", "Make shared (default: false)") orelse false;

    const mrubyc = if (opt_use_shared) b.addSharedLibrary(.{
        .name = "mrubyc",
        .target = target,
        .optimize = optimize,
    }) else b.addStaticLibrary(.{
        .name = "mrubyc",
        .target = target,
        .optimize = optimize,
    });
    mrubyc.linkLibC();
    mrubyc.addIncludePath(b.path("./src"));
    mrubyc.addIncludePath(b.path("./hal"));
    mrubyc.addIncludePath(b.path("./hal/posix"));
    mrubyc.addCSourceFile(.{
        .file = b.path("./hal/posix/hal.c"),
    });
    mrubyc.addCSourceFiles(.{
        .root = b.path("./src"),
        .files = &.{
            "alloc.c",
            "c_array.c",
            "c_hash.c",
            "c_math.c",
            "c_numeric.c",
            "c_object.c",
            "c_proc.c",
            "c_range.c",
            "c_string.c",
            "class.c",
            "console.c",
            "error.c",
            "global.c",
            "keyvalue.c",
            "load.c",
            "mrblib.c",
            "rrt0.c",
            "symbol.c",
            "value.c",
            "vm.c",
        },
    });
    mrubyc.installHeader(b.path("./src/mrubyc.h"), "mrubyc");

    b.installArtifact(mrubyc);
}
