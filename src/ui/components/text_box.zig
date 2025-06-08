const SDL = @import("sdl2");
const std = @import("std");
const LabelRect = @import("../../common/structures.zig").LabelRect;

pub fn text_box(renderer: SDL.Renderer, label: []const u8, label_rect: LabelRect) !void {
    var buffer: [128]u8 = undefined;
    const string = try std.fmt.bufPrintZ(buffer[0..], "{s}", .{label});

    const font = try SDL.ttf.openFont("src/fonts/CursedTimerUlil.ttf", label_rect.label_size);
    defer font.close();
    const text_surface = try font.renderTextSolid(string, SDL.Color.white);
    defer text_surface.destroy();

    const text = try SDL.createTextureFromSurface(renderer, text_surface);
    defer text.destroy();

    const text_info = try text.query();
    const text_width = @as(c_int, @intCast(text_info.width));
    const text_height = @as(c_int, @intCast(text_info.height));

    try renderer.copy(text, .{
        .x = label_rect.x,
        .y = label_rect.y,
        .width = text_width,
        .height = text_height,
    }, null);
}
