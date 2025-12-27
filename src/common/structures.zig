const std = @import("std");
const helpers = @import("../common/helpers.zig");
const fixDecimal = helpers.fixDecimal;
const getFractionCount = helpers.getFractionCount;
const FRACTION_COUNT = 14;

pub const InputValue = struct {
    value: std.ArrayList(u8),
    has_period: bool,
};

pub const CalcState = struct {
    allocator: std.mem.Allocator,
    prev_input: InputValue,
    operation: u8,
    input: InputValue,

    pub fn init(allocator: std.mem.Allocator) CalcState {
        return CalcState{
            .allocator = allocator,
            .prev_input = InputValue{
                .value = .empty,
                .has_period = false,
            },
            .operation = '~',
            .input = InputValue{
                .value = .empty,
                .has_period = false,
            },
        };
    }
    pub fn reset(self: *CalcState) void {
        self.input.value = .empty;
        self.input.has_period = false;
        self.operation = '~';
        self.prev_input.value = .empty;
        self.prev_input.has_period = false;
    }
    pub fn appendInput(self: *CalcState, _input: u8) void {
        if ((self.input.value.items.len == 128) or
            (_input == '.' and self.input.has_period)) return;
        self.input.value.append(self.allocator, _input) catch unreachable;
        if (_input == '.')
            self.input.has_period = true;
    }
    pub fn popLastInput(self: *CalcState) void {
        if (self.input.value.items.len == 0) return;
        _ = self.input.value.pop();
        self.input.has_period = helpers.check_has_period(self.input.value.items);
    }
    pub fn updateOpetation(self: *CalcState, _opeation: u8) void {
        self.prev_input.value = .empty;
        self.prev_input.value.appendSlice(self.allocator, self.input.value.items) catch unreachable;
        self.prev_input.has_period = self.input.has_period;
        self.input.value = .empty;
        self.input.has_period = false;
        self.operation = _opeation;
    }
    pub fn calculate(self: *CalcState) void {
        if (self.operation == '~') return;

        var buffer: [128]u8 = undefined;
        const input = std.fmt.parseFloat(f128, self.input.value.items) catch 0;
        const prev_input = std.fmt.parseFloat(f128, self.prev_input.value.items) catch 0;
        var result: []const u8 = undefined;
        switch (self.operation) {
            '+' => {
                result = fixDecimal(&buffer, input + prev_input, FRACTION_COUNT);
            },
            '-' => {
                result = fixDecimal(&buffer, prev_input - input, FRACTION_COUNT);
            },
            'x' => {
                result = fixDecimal(&buffer, input * prev_input, FRACTION_COUNT);
            },
            '/' => {
                result = fixDecimal(&buffer, prev_input / input, FRACTION_COUNT);
            },
            else => {},
        }
        self.input.value = .empty;
        self.input.value.appendSlice(self.allocator, result) catch unreachable;
        self.input.has_period = helpers.check_has_period(self.input.value.items);
        self.operation = '~';
    }
};

pub const MouseClickData = struct {
    clicked: bool,
    x: i32,
    y: i32,

    pub fn init() MouseClickData {
        return MouseClickData{ .clicked = false, .x = 0, .y = 0 };
    }
    pub fn updateData(self: *MouseClickData, clicked: bool, x: i32, y: i32) void {
        self.clicked = clicked;
        self.x = x;
        self.y = y;
    }
};

pub const LabelRect = struct {
    x: c_int,
    y: c_int,
    label_size: c_int,
};

pub const ButtonRect = struct {
    x: c_int,
    y: c_int,
    width: c_int,
    height: c_int,
    label_size: c_int,
};
