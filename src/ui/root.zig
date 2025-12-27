const SDL = @import("sdl2");
const button = @import("./components/button.zig").button;
const text_box = @import("./components/text_box.zig").text_box;
const std = @import("std");
const structures = @import("../common/structures.zig");
const CalcState = structures.CalcState;
const MouseClickData = structures.MouseClickData;
const helpers = @import("../common/helpers.zig");

const numbers = [10]u8{ '9', '8', '7', '6', '5', '4', '3', '2', '1', '0' };
const symbols = [7]u8{ '+', '-', 'x', '/', '=', '.', '«' };

pub fn draw(renderer: *SDL.Renderer, calc_state: *CalcState, mouse_click_data: *MouseClickData) !void {
    // Rendering number buttons
    var y_index: usize = 1;
    for (numbers, 0..) |number, i| {
        var buf: [@sizeOf(usize)]u8 = undefined;
        const x = (150 * @as(c_int, @intCast((i + 2) % 2)) + 50);
        const y = 50 * @as(c_int, @intCast(y_index));
        try button(
            renderer,
            try std.fmt.bufPrint(&buf, "{c}", .{number}),
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
            calc_state.appendInput(number);
        }
    }

    // Rendering symbols
    y_index = 1;
    for (symbols, 0..) |symbol, i| {
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
        if (mouse_click_data.clicked and
            mouse_click_data.x >= x and mouse_click_data.x <= x + 100 and
            mouse_click_data.y >= y and mouse_click_data.y <= y + 40)
        {
            if (symbol == '=') {
                calc_state.calculate();
            } else if (symbol == '«') {
                calc_state.popLastInput();
            } else if (symbol == '.') {
                calc_state.appendInput('.');
            } else {
                calc_state.updateOpetation(symbol);
            }
        }
    }

    // Render text boxes
    // Result box
    text_box(
        renderer,
        if (calc_state.input.value.items.len > 0) calc_state.input.value.items else " ",
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
