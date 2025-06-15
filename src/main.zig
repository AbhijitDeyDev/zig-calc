const std = @import("std");
const SDL = @import("sdl2");
const draw = @import("ui/root.zig").draw;
const CalcState = @import("./common/structures.zig").CalcState;
const MouseClickData = @import("./common/structures.zig").MouseClickData;

const THEME_COLOR = SDL.Color.rgb(153, 51, 204);

pub fn main() !void {
    try SDL.init(.{
        .video = true,
        .events = true,
    });
    defer SDL.quit();

    try SDL.ttf.init();
    defer SDL.ttf.quit();

    var window = try SDL.createWindow(
        "Zig Calc (SDL2)",
        .{ .centered = {} },
        .{ .centered = {} },
        640,
        480,
        .{ .vis = .shown },
    );
    defer window.destroy();

    var renderer = try SDL.createRenderer(
        window,
        null,
        .{
            .accelerated = true,
            .software = false,
            .present_vsync = true,
            .target_texture = false,
        },
    );
    defer renderer.destroy();

    var calc_state = CalcState.init();

    mainLoop: while (true) {
        var mouse_click_data = MouseClickData.init();
        while (SDL.pollEvent()) |ev| {
            switch (ev) {
                .quit => break :mainLoop,
                .mouse_button_down => {
                    mouse_click_data.updateData(
                        true,
                        ev.mouse_button_down.x,
                        ev.mouse_button_down.y,
                    );
                },
                else => {},
            }
        }

        // Set background colour
        try renderer.setColorRGB(0x22, 0x22, 0x22);
        try renderer.clear();

        try renderer.setColor(THEME_COLOR);
        try draw(&renderer, &calc_state, &mouse_click_data);

        renderer.present();
        SDL.delay(1000 / 30); // Limit FPS around 30
    }
}
