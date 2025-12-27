const std = @import("std");

pub fn check_has_period(value: []u8) bool {
    return std.mem.indexOf(u8, value, ".") != null;
}

pub fn getFractionCount(value: f128, max: usize) usize {
    var buffer: [128]u8 = undefined;
    const formatted = std.fmt.bufPrint(&buffer, "{d}", .{value}) catch unreachable;

    const dotIndex = std.mem.indexOf(u8, formatted, ".");
    if (dotIndex) |idx| {
        const precision = formatted.len - idx - 1;
        return if (precision > max) max else precision;
    }
    return 0; // No decimal point found
}

pub fn fixDecimal(buffer: []u8, value: f128, max: usize) []const u8 {
    return std.fmt.bufPrint(
        buffer,
        "{d:.[1]}",
        .{
            value,
            getFractionCount(value, max),
        },
    ) catch unreachable;
}
