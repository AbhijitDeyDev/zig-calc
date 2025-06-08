const std = @import("std");
const fixDecimal = @import("../common/helpers.zig").fixDecimal;

pub const CalcState = struct {
    prev_input: f128,
    operation: u8,
    input: f128,

    pub fn init() CalcState {
        return CalcState{ .prev_input = 0, .operation = '~', .input = 0 };
    }

    pub fn reset(self: *CalcState) void {
        self.input = 0;
        self.operation = '~';
        self.prev_input = 0;
    }

    pub fn updateInput(self: *CalcState, _input: f128) void {
        self.input = _input;
    }
    pub fn updateOpetation(self: *CalcState, _opeation: u8) void {
        self.prev_input = self.input;
        self.input = 0;
        self.operation = _opeation;
    }
    pub fn calculate(self: *CalcState) void {
        var buffer: [128]u8 = undefined;
        switch (self.operation) {
            '+' => {
                self.input = std.fmt.parseFloat(
                    f128,
                    fixDecimal(&buffer, self.input + self.prev_input, 14),
                ) catch unreachable;
            },
            '-' => {
                self.input = std.fmt.parseFloat(
                    f128,
                    fixDecimal(&buffer, self.prev_input - self.input, 14),
                ) catch unreachable;
            },
            'x' => {
                self.input = std.fmt.parseFloat(
                    f128,
                    fixDecimal(&buffer, self.input * self.prev_input, 14),
                ) catch unreachable;
            },
            '/' => {
                self.input = std.fmt.parseFloat(
                    f128,
                    fixDecimal(&buffer, self.prev_input / self.input, 14),
                ) catch unreachable;
            },
            else => {},
        }
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
