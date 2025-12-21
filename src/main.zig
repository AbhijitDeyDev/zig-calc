const std = @import("std");
const SDL = @import("sdl2");
const draw = @import("ui/root.zig").draw;
const helpers = @import("./common/helpers.zig");
const appendDigit = helpers.appendDigit;
const structures = @import("./common/structures.zig");
const CalcState = structures.CalcState;
const MouseClickData = structures.MouseClickData;

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
        670,
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
                .key_down => {
                    switch (ev.key_down.keycode) {
                        .@"0", .keypad_0 => {
                            calc_state.updateInput(appendDigit(calc_state.input, 0, calc_state.is_period_input));
                        },
                        .@"1", .keypad_1 => {
                            calc_state.updateInput(appendDigit(calc_state.input, 1, calc_state.is_period_input));
                        },
                        .@"2", .keypad_2 => {
                            calc_state.updateInput(appendDigit(calc_state.input, 2, calc_state.is_period_input));
                        },
                        .@"3", .keypad_3 => {
                            calc_state.updateInput(appendDigit(calc_state.input, 3, calc_state.is_period_input));
                        },
                        .@"4", .keypad_4 => {
                            calc_state.updateInput(appendDigit(calc_state.input, 4, calc_state.is_period_input));
                        },
                        .@"5", .keypad_5 => {
                            calc_state.updateInput(appendDigit(calc_state.input, 5, calc_state.is_period_input));
                        },
                        .@"6", .keypad_6 => {
                            calc_state.updateInput(appendDigit(calc_state.input, 6, calc_state.is_period_input));
                        },
                        .@"7", .keypad_7 => {
                            calc_state.updateInput(appendDigit(calc_state.input, 7, calc_state.is_period_input));
                        },
                        .@"8", .keypad_8 => {
                            calc_state.updateInput(appendDigit(calc_state.input, 8, calc_state.is_period_input));
                        },
                        .@"9", .keypad_9 => {
                            calc_state.updateInput(appendDigit(calc_state.input, 9, calc_state.is_period_input));
                        },
                        .equals, .keypad_plus => {
                            // Handle Shift+'=' for '+' input
                            if (ev.key_down.keycode == .equals and ev.key_down.modifiers.storage != 1) continue;
                            calc_state.updateOpetation('+');
                        },
                        .minus, .keypad_minus => {
                            calc_state.updateOpetation('-');
                        },
                        .asterisk, .keypad_multiply => {
                            calc_state.updateOpetation('x');
                        },
                        .slash, .keypad_divide => {
                            calc_state.updateOpetation('/');
                        },
                        .@"return", .keypad_enter => {
                            calc_state.calculate();
                        },
                        .period, .keypad_period => {
                            calc_state.setPoint();
                        },
                        .backspace => {
                            calc_state.updateInput(helpers.popLastDigit(calc_state.input));
                        },
                        else => {},
                    }
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
