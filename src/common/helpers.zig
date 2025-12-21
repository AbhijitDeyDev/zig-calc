const std = @import("std");

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

pub fn appendDigit(value: f128, digit: usize, insert_period: bool) f128 {
    var buffer: [128]u8 = undefined;
    const formatted = std.fmt.bufPrint(&buffer, "{d}{s}{d}", .{
        value,
        if (insert_period) "." else "",
        digit,
    }) catch unreachable;

    return std.fmt.parseFloat(f128, formatted) catch value;
}

pub fn popLastDigit(value: f128) f128 {
    var buffer: [128]u8 = undefined;
    const formatted = std.fmt.bufPrint(&buffer, "{d}", .{value}) catch unreachable;

    const dotIndex = std.mem.indexOf(u8, formatted, ".");
    if (dotIndex) |idx| {
        if (formatted.len - idx - 1 == 1) {
            return @floor(value); // Remove decimal if only one digit remains
        }
        return std.fmt.parseFloat(f128, formatted[0 .. formatted.len - 1]) catch value;
    } else if (std.mem.eql(u8, formatted, "0")) {
        return value;
    } else if (formatted.len == 1 or (formatted.len == 2 and formatted[0] == '-')) {
        return 0;
    } else {
        return std.fmt.parseFloat(f128, formatted[0 .. formatted.len - 1]) catch value;
    }
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
