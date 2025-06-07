const SDL = @import("sdl2");
const button = @import("./components/button.zig").button;
const text_box = @import("./components/text_box.zig").text_box;
const std = @import("std");
const CalcState = @import("../common/structures.zig").CalcState;
const MouseClickData = @import("../common/structures.zig").MouseClickData;

pub fn draw(renderer: SDL.Renderer, calc_state: *CalcState, mouse_click_data: MouseClickData) !void {
    // Set background colour
    try renderer.setColorRGB(0x22, 0x22, 0x22);
    try renderer.setDrawBlendMode(.multiply);

    const font = try SDL.ttf.openFont("src/fonts/Poppins.ttf", 18);
    defer font.close();

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
            font,
        );
        y_index += (i + 2) % 2;

        // Handle click event
        if (mouse_click_data.clicked and
            mouse_click_data.x >= x and mouse_click_data.x <= x + 140 and
            mouse_click_data.y >= y and mouse_click_data.y <= y + 40)
        {
            calc_state.updateInput(calc_state.input * 10 + i);
        }
    }

    // Rendering symbols
    const symbols = [5]u8{ '+', '-', 'x', '/', '=' };
    for (0.., symbols) |i, symbol| {
        var buf: [8]u8 = undefined;
        const x = 400;
        const y = 50 * @as(c_int, @intCast(i + 1));
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
            font,
        );

        // Handle click event

        // Handle click event
        if (mouse_click_data.clicked and
            mouse_click_data.x >= x and mouse_click_data.x <= x + 100 and
            mouse_click_data.y >= y and mouse_click_data.y <= y + 40)
        {
            calc_state.updateOpetation(symbol);
        }
    }

    // Render text boxes
    // Result box
    var result_buf: [13]u8 = undefined;
    text_box(
        renderer,
        std.fmt.bufPrint(&result_buf, "{d}", .{calc_state.input}) catch "Max reached",
        .{
            .label_size = 40,
            .x = 50,
            .y = 350,
        },
    ) catch {
        try text_box(
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
                .y = 350,
            },
        );
    }

    if (mouse_click_data.clicked) {}
}
