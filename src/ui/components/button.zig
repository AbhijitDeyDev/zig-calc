const SDL = @import("sdl2");
const std = @import("std");
const ButtonRect = @import("../../common/structures.zig").ButtonRect;

pub fn button(renderer: SDL.Renderer, label: []const u8, rect: ButtonRect, _font: ?SDL.ttf.Font) !void {
    try renderer.drawRect(.{
        .height = rect.height,
        .width = rect.width,
        .x = rect.x,
        .y = rect.y,
    });

    var b = std.mem.zeroes([8]u8);
    const string = try std.fmt.bufPrintZ(b[0..], "{s}", .{label});

    const font: SDL.ttf.Font = _font orelse blk: {
        const newFont = try SDL.ttf.openFont("src/fonts/Poppins.ttf", rect.label_size);
        defer newFont.close();
        break :blk newFont;
    };
    const text_surface = try font.renderTextSolid(string, SDL.Color.white);
    defer text_surface.destroy();

    const text = try SDL.createTextureFromSurface(renderer, text_surface);
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
