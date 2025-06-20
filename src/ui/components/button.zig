const SDL = @import("sdl2");
const std = @import("std");
const ButtonRect = @import("../../common/structures.zig").ButtonRect;

pub fn button(renderer: *SDL.Renderer, label: []const u8, rect: ButtonRect) !void {
    try renderer.fillRect(.{
        .height = rect.height,
        .width = rect.width,
        .x = rect.x,
        .y = rect.y,
    });

    var buffer: [8]u8 = undefined;
    const string = try std.fmt.bufPrintZ(buffer[0..], "{s}", .{label});

    const font = try SDL.ttf.openFont("src/fonts/CursedTimerUlil.ttf", rect.label_size);
    defer font.close();
    const text_surface = try font.renderTextSolid(string, SDL.Color.white);
    defer text_surface.destroy();

    const text = try SDL.createTextureFromSurface(renderer.*, text_surface);
    defer text.destroy();

    const text_info = try text.query();
    const text_width = @as(c_int, @intCast(text_info.width));
    const text_height = @as(c_int, @intCast(text_info.height));
    const gapX = rect.x + @divFloor(rect.width - text_width, 2);
    const gapY = rect.y + @divFloor(rect.height - text_height, 2);

    try renderer.copy(text, .{
        .x = gapX,
        .y = gapY,
        .width = text_width,
        .height = text_height,
    }, null);
}
