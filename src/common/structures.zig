const std = @import("std");
const helpers = @import("../common/helpers.zig");
const fixDecimal = helpers.fixDecimal;
const getFractionCount = helpers.getFractionCount;
const FRACTION_COUNT = 14;

pub const CalcState = struct {
    prev_input: f128,
    operation: u8,
    input: f128,
    is_period_input: bool,
    has_period: bool,

    pub fn init() CalcState {
        return CalcState{
            .prev_input = 0,
            .operation = '~',
            .input = 0,
            .is_period_input = false,
            .has_period = false,
        };
    }
    pub fn reset(self: *CalcState) void {
        self.input = 0;
        self.operation = '~';
        self.prev_input = 0;
        self.is_period_input = false;
    }
    pub fn updateInput(self: *CalcState, _input: f128) void {
        self.input = _input;
        self.is_period_input = false;
        self.has_period = getFractionCount(_input, FRACTION_COUNT) > 0;
    }
    pub fn setPoint(self: *CalcState) void {
        if (!self.has_period)
            self.is_period_input = true;
        self.has_period = true;
    }
    pub fn updateOpetation(self: *CalcState, _opeation: u8) void {
        self.prev_input = self.input;
        self.input = 0;
        self.operation = _opeation;
        self.is_period_input = false;
        self.has_period = false;
    }
    pub fn calculate(self: *CalcState) void {
        var buffer: [128]u8 = undefined;
        switch (self.operation) {
            '+' => {
                const result = self.input + self.prev_input;
                self.has_period = getFractionCount(result, FRACTION_COUNT) > 0;
                self.input = std.fmt.parseFloat(
                    f128,
                    fixDecimal(&buffer, result, FRACTION_COUNT),
                ) catch unreachable;
            },
            '-' => {
                const result = self.prev_input - self.input;
                self.has_period = getFractionCount(result, FRACTION_COUNT) > 0;
                self.input = std.fmt.parseFloat(
                    f128,
                    fixDecimal(&buffer, result, FRACTION_COUNT),
                ) catch unreachable;
            },
            'x' => {
                const result = self.input * self.prev_input;
                self.has_period = getFractionCount(result, FRACTION_COUNT) > 0;
                self.input = std.fmt.parseFloat(
                    f128,
                    fixDecimal(&buffer, result, FRACTION_COUNT),
                ) catch unreachable;
            },
            '/' => {
                const result = self.prev_input / self.input;
                self.has_period = getFractionCount(result, FRACTION_COUNT) > 0;
                self.input = std.fmt.parseFloat(
                    f128,
                    fixDecimal(&buffer, result, FRACTION_COUNT),
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
