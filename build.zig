const std = @import("std");
const builtin = @import("builtin");
const sdl2 = @import("sdl");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const exe_mod = b.createModule(.{
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });
    const exe = b.addExecutable(.{
        .name = "zig_calc",
        .root_module = exe_mod,
    });

    const sdk = sdl2.init(b, .{});
    sdk.link(exe, .dynamic, .SDL2);
    sdk.link(exe, .dynamic, .SDL2_ttf);
    exe.root_module.addImport("sdl2", sdk.getWrapperModule());

    if (builtin.os.tag == .windows) {
        b.installFile("SDL2/bin/SDL2.dll", "./bin/SDL2.dll");
        b.installFile("SDL2/bin/SDL2_ttf.dll", "./bin/SDL2_ttf.dll");
        b.installFile("src/fonts/CursedTimerUlil.ttf", "./bin/src/fonts/CursedTimerUlil.ttf");
    }

    b.installArtifact(exe);
    const run_cmd = b.addRunArtifact(exe);
    run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }
    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);
    const exe_unit_tests = b.addTest(.{
        .root_module = exe_mod,
    });

    const run_exe_unit_tests = b.addRunArtifact(exe_unit_tests);
    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&run_exe_unit_tests.step);
}
