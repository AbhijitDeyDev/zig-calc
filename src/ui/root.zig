const SDL = @import("sdl2");
const button = @import("./components/button.zig").button;
const text_box = @import("./components/text_box.zig").text_box;
const std = @import("std");
const CalcState = @import("../common/structures.zig").CalcState;
const MouseClickData = @import("../common/structures.zig").MouseClickData;
const helpers = @import("../common/helpers.zig");

pub fn draw(renderer: *SDL.Renderer, calc_state: *CalcState, mouse_click_data: *MouseClickData) !void {
    // Rendering number buttons
    var y_index: usize = 1;
    for (0..10) |i| {
        var buf: [@sizeOf(usize)]u8 = undefined;
        const x = (150 * @as(c_int, @intCast((i + 2) % 2)) + 50);
        const y = 50 * @as(c_int, @intCast(y_index));
        try button(
            renderer,
            try std.fmt.bufPrint(&buf, "{}", .{i}),
            .{
                .x = x,
                .y = y,
                .width = 140,
                .height = 40,
                .label_size = 16,
            },
        );
        y_index += (i + 2) % 2;

        // Handle click event
        if (mouse_click_data.clicked and
            mouse_click_data.x >= x and mouse_click_data.x <= x + 140 and
            mouse_click_data.y >= y and mouse_click_data.y <= y + 40)
        {
            calc_state.updateInput(helpers.appendDigit(calc_state.input, i));
        }
    }

    // Rendering symbols
    const symbols = [6]u8{ '+', '-', 'x', '/', '=', '«' };
    y_index = 1;
    for (0.., symbols) |i, symbol| {
        var buf: [1]u8 = undefined;
        const x = @as(c_int, @intCast(400 + ((i % 2) * 120)));
        const y = 50 * @as(c_int, @intCast(y_index));
        try button(
            renderer,
            try std.fmt.bufPrint(&buf, "{c}", .{symbol}),
            .{
                .x = x,
                .y = y,
                .width = 100,
                .height = 40,
                .label_size = 18,
            },
        );
        y_index += (i + 2) % 2;

        // Handle click event

        // Handle click event
        if (mouse_click_data.clicked and
            mouse_click_data.x >= x and mouse_click_data.x <= x + 100 and
            mouse_click_data.y >= y and mouse_click_data.y <= y + 40)
        {
            if (symbol == '=') {
                calc_state.calculate();
            } else if (symbol == '«') {
                calc_state.updateInput(helpers.popLastDigit(calc_state.input));
            } else {
                calc_state.updateOpetation(symbol);
            }
        }
    }

    // Render text boxes
    // Result box
    var buffer: [128]u8 = undefined;
    text_box(
        renderer,
        helpers.fixDecimal(&buffer, calc_state.input, 14),
        .{
            .label_size = 40,
            .x = 50,
            .y = 350,
        },
    ) catch {
        return try text_box(
            renderer,
            "Max reached",
            .{
                .label_size = 40,
                .x = 50,
                .y = 350,
            },
        );
    };
    // Operation box
    if (calc_state.operation != '~') {
        var op_buf: [8]u8 = undefined;
        try text_box(
            renderer,
            try std.fmt.bufPrint(&op_buf, "{c}", .{calc_state.operation}),
            .{
                .label_size = 30,
                .x = 400,
                .y = 260,
            },
        );
    }

    // Render clear button
    const x = 50;
    const y = 400;
    try button(
        renderer,
        "Clear",
        .{
            .x = x,
            .y = y,
            .width = 100,
            .height = 40,
            .label_size = 18,
        },
    );
    // Handle clear button click
    if (mouse_click_data.clicked and
        mouse_click_data.x >= x and mouse_click_data.x <= x + 100 and
        mouse_click_data.y >= y and mouse_click_data.y <= y + 40)
    {
        calc_state.reset();
    }
}
